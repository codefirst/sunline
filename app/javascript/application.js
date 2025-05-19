// Entry point for the build script in your package.json

import jQuery from "jquery";
window.jQuery = window.$ = jQuery;

import "bootstrap/dist/js/bootstrap";

import "@fortawesome/fontawesome-free/js/all";

import { editorFromTextArea } from "./codemirror";
window.editorFromTextArea = editorFromTextArea;

import "./darkmode";
