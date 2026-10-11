// const fs = require('fs');
// const path = require('path');

// function walk(dir) {
//   let results = [];
//   const list = fs.readdirSync(dir);
//   list.forEach(file => {
//     file = path.join(dir, file);
//     const stat = fs.statSync(file);
//     if (stat && stat.isDirectory()) { 
//       results = results.concat(walk(file));
//     } else if (file.endsWith('.js') || file.endsWith('.jsx')) {
//       results.push(file);
//     }
//   });
//   return results;
// }

// const files = walk('app/[locale]/dashboard');
// let fixed = 0;

// files.forEach(file => {
//   let content = fs.readFileSync(file, 'utf8');
//   let original = content;
  
//   // To avoid double replacement (e.g. replacing ../ and then replacing the result of that),
//   // we first replace all ../../.. with a temporary placeholder, etc.
//   // Actually, string.replace(regex) over the whole file works fine if we do it carefully.
//   // Wait, if I replace ../../ with ../../../, the newly formed ../../../ won't be matched by a subseqent regex if I don't run them sequentially. BUT I am running sequentially.
//   // Deepest first:
//   // Replace: from "../../../components" --> from "../../../../components"
//   content = content.replace(/from\s+['"]\.\.\/\.\.\/\.\.\/(components|context|utils)/g, 'from "../../../../$1');
  
//   // Replace: from "../../components" --> from "../../../components"
//   content = content.replace(/from\s+['"]\.\.\/\.\.\/(components|context|utils)/g, 'from "../../../$1');
  
//   // Replace: from "../components" --> from "../../components"
//   // Wait, if I already replaced ../../ with ../../../, the string now has ../../../.
//   // If I now blindly replace ../ with ../., I will turn ../../../ into .././../../ which is wrong.
//   // Regex needs to be precise: exactly one ../ followed by components
//   content = content.replace(/from\s+['"]\.\.\/(components|context|utils)/g, 'from "../../$1');

//   if (content !== original) {
//     fs.writeFileSync(file, content);
//     fixed++;
//   }
// });

// console.log('Fixed imports in ' + fixed + ' files.');


// This code is comments because, decided to fix the imports manually since there are only a few files. The regex is a bit tricky and I don't want to risk breaking something by running an automated script on all files.