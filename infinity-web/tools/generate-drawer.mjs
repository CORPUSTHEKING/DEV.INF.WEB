import fs from 'fs';

const SCAN_DIR = './components/drawer/scan';
const OUTPUT_FILE = './components/drawer/scan.js';

if (!fs.existsSync(SCAN_DIR)) fs.mkdirSync(SCAN_DIR, { recursive: true });

const files = fs.readdirSync(SCAN_DIR).filter(f => f.endsWith('.js'));

let imports = '// AUTO-GENERATED DRAWER SOCKET: DO NOT EDIT\n';
let moduleMap = 'export const dynamicDrawer = {\n';

files.forEach(file => {
    const name = file.replace('.js', '');
    imports += `import ${name} from './scan/${file}';\n`;
    moduleMap += `  '${name}': ${name},\n`;
});

moduleMap += '};';

fs.writeFileSync(OUTPUT_FILE, `${imports}\n${moduleMap}`);
console.log(`[Drawer] Socket updated: Found ${files.length} modules in drawer/scan/`);
