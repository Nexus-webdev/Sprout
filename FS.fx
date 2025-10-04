# create the filesystem thread;
thread fs ? {
 onecho {
  let target = echo.value;
  
  if target.to == 'fs' ? {
   switch target.type ? {
    case 'DIR' ? dir target.file;
    case 'READ' ? read target.file;
    case 'WRITE' ? write target.file, target.content;
   };
  };
 };
 
 function read(file) {
  let data = -read file;
  echo { responsetype: 'READ', data };
 };

 function dir(directory) {
  -cd directory;
  echo { responsetype: 'DIR', data: `Successfully set working directory to: '${directory}'` };
 };

 function write(file, content) {
  -write file >> content;
  echo { responsetype: 'WRITE', data: `Successfully written to file: '${file}'` };
 };
};

# Pipline echoes from the main thread to the 'fs' thread;
onecho {
 fs:echo echo.value;
};

# Pipline echoes from the 'fs' thread to the main thread;
fs:onecho {
 echo { ...echo.value, from: 'fs' };
};