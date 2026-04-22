import fs from 'fs';

const SCAN_DIR = './components/scroll/scan';
const OUTPUT_FILE = './components/scroll/scan.js';

if (!fs.existsSync(SCAN_DIR)) fs.mkdirSync(SCAN_DIR, { recursive: true });

const files = fs.readdirSync(SCAN_DIR).filter(f => f.endsWith('.js'));

let imports = '// AUTO-GENERATED SCROLL SOCKET: DO NOT EDIT\n';
let moduleMap = 'export const dynamicScroll = {\n';

files.forEach(file => {
    const name = file.replace('.js', '');
    imports += `import ${name} from './scan/${file}';\n`;
    moduleMap += `  '${name}': ${name},\n`;
});

moduleMap += '};';

fs.writeFileSync(OUTPUT_FILE, `${imports}\n${moduleMap}`);
console.log(`[Scroll] Socket updated: Found ${files.length} modules in scroll/scan/`);
