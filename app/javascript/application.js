// Entry point for the build script in your package.json

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;

import "bootstrap/dist/js/bootstrap";
import CodeMirror from "codemirror";"codemirror/lib/codemirror";
import "codemirror/mode/shell/shell";
import "@fortawesome/fontawesome-free/js/all";

import "./bootstrap-fileupload";

window.CodeMirror = CodeMirror;
