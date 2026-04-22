import js from "@eslint/js";
import globals from "globals";

export default [
    js.configs.recommended,
    {
        languageOptions: {
            ecmaVersion: "latest",
            sourceType: "module",
            globals: {
                ...globals.browser,
                ...globals.node,
                marked: "readonly", // For your markdown parsing
                ui: "readonly",     // For your global UI controller
                config: "readonly"  // For your site config
            },
        },
        rules: {
            "no-unused-vars": ["warn", { "argsIgnorePattern": "^_" }],
            "no-console": "off", // Allowed for your CLI tools/logging
            "indent": ["error", 4],
            "quotes": ["error", "single"],
            "semi": ["error", "always"]
        }
    }
];
