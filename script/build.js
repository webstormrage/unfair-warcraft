const fs = require('fs');
const path = require('path');

const entryPath = '../src/';
const entry = 'unfair-warcraft-main.lua';

const distPath = '../dist/';
const dist = 'script.lua';

const walkSync = (dir, filelist=[]) => {
    const files = fs.readdirSync(dir);
    files.forEach(file => {
      if (fs.statSync(dir + file).isDirectory()) {
        filelist = walkSync(dir + file + '/', filelist);
      } else if (/.+\.lua$/.test(file) && file !== entry){
        filelist.push(dir + file);
      }
    });
    return filelist;
};

const script = [...walkSync('../src/'), entryPath + entry]
.map(file => fs.readFileSync(file, 'utf-8'))
.reduce((script, file) => script + '\n\n' + file);


fs.writeFileSync(distPath + dist, script);