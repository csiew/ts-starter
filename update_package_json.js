fs = require('fs');
var name = 'package.json';
var m = JSON.parse(fs.readFileSync(name).toString());
m.scripts = {
  "dev": "tsnd --respawn index.ts",
  "migrate": "sequelize db:migrate",
  "start": "node dist/index.js",
  "build": "tsc",
  "test": "echo \"Error: no test specified\" && exit 1",
  "lint": "eslint . --ext .ts"
};
fs.writeFileSync(name, JSON.stringify(m));
