import fs from 'fs';

const SCAN_DIR = './components/cards/scan';
const OUTPUT_FILE = './components/cards/scan.js';

if (!fs.existsSync(SCAN_DIR)) fs.mkdirSync(SCAN_DIR, { recursive: true });

const files = fs.readdirSync(SCAN_DIR).filter(f => f.endsWith('.js'));

let imports = '// AUTO-GENERATED CARDS SOCKET: DO NOT EDIT\n';
let cardMap = 'export const dynamicCards = {\n';

files.forEach(file => {
    const cardName = file.replace('.js', '');
    // Path is relative to components/cards/scan.js
    imports += `import ${cardName} from './scan/${file}';\n`;
    cardMap += `  '${cardName}': ${cardName},\n`;
});

cardMap += '};';

fs.writeFileSync(OUTPUT_FILE, `${imports}\n${cardMap}`);
console.log(`[Cards] Socket updated: Found ${files.length} dynamic modules in cards/scan/`);
