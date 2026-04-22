import fs from 'fs';

const SCAN_DIR = './components/cardActions/scan';
const OUTPUT_FILE = './components/cardActions/scan.js';

if (!fs.existsSync(SCAN_DIR)) fs.mkdirSync(SCAN_DIR, { recursive: true });

const files = fs.readdirSync(SCAN_DIR).filter(f => f.endsWith('.js'));

let imports = '// AUTO-GENERATED ACTIONS SOCKET: DO NOT EDIT\n';
let actionMap = 'export const dynamicActions = {\n';

files.forEach(file => {
    const actionName = file.replace('.js', '');
    // Path is relative to components/cardActions/scan.js
    imports += `import ${actionName} from './scan/${file}';\n`;
    actionMap += `  '${actionName}': ${actionName},\n`;
});

actionMap += '};';

fs.writeFileSync(OUTPUT_FILE, `${imports}\n${actionMap}`);
console.log(`[CardActions] Socket updated: Found ${files.length} action modules in cardActions/scan/`);
