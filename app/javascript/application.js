// Entry point for the build script in your package.json

import { Tooltip } from "bootstrap/dist/js/bootstrap";
window.Tooltip = Tooltip;

import "@fortawesome/fontawesome-free/js/all";

import { editorFromTextArea } from "./codemirror";
window.editorFromTextArea = editorFromTextArea;

import "./darkmode";

import "./data-loading-text";
