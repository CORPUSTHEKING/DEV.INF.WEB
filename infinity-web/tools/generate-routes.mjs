import fs from 'fs';

const SCAN_DIR = './components/router/scan';
const OUTPUT_FILE = './components/router/scan.js';

if (!fs.existsSync(SCAN_DIR)) fs.mkdirSync(SCAN_DIR, { recursive: true });

const files = fs.readdirSync(SCAN_DIR).filter(f => f.endsWith('.js'));

let imports = '// AUTO-GENERATED SOCKET: DO NOT EDIT\n';
let routeMap = 'export const dynamicRoutes = {\n';

files.forEach(file => {
    const routeName = file.replace('.js', '');
    // Path is relative to components/router/scan.js
    imports += `import ${routeName}Handler from './scan/${file}';\n`;
    routeMap += `  '${routeName}': ${routeName}Handler,\n`;
});

routeMap += '};';

fs.writeFileSync(OUTPUT_FILE, `${imports}\n${routeMap}`);
console.log(`[Router] Socket updated: Found ${files.length} dynamic modules in router/scan/`);
