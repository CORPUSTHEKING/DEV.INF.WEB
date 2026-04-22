import fs from 'fs';

const SCAN_DIR = './components/searchdock/scan';
const OUTPUT_FILE = './components/searchdock/scan.js';

if (!fs.existsSync(SCAN_DIR)) fs.mkdirSync(SCAN_DIR, { recursive: true });

const files = fs.readdirSync(SCAN_DIR).filter(f => f.endsWith('.js'));

let imports = '// AUTO-GENERATED SEARCHDOCK SOCKET: DO NOT EDIT\n';
let moduleMap = 'export const dynamicSearchdock = {\n';

files.forEach(file => {
    const name = file.replace('.js', '');
    imports += `import ${name} from './scan/${file}';\n`;
    moduleMap += `  '${name}': ${name},\n`;
});

moduleMap += '};';

fs.writeFileSync(OUTPUT_FILE, `${imports}\n${moduleMap}`);
console.log(`[Searchdock] Socket updated: Found ${files.length} modules in searchdock/scan/`);
