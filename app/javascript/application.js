// Entry point for the build script in your package.json

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;

import("bootstrap/dist/js/bootstrap"); // use () to import jQuery

import "@fortawesome/fontawesome-free/js/all";

import("jasny-bootstrap/dist/js/jasny-bootstrap"); // use () to import $

import { editorFromTextArea } from "./codemirror";
window.editorFromTextArea = editorFromTextArea;
