// Entry point for the build script in your package.json

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;

import("bootstrap/dist/js/bootstrap"); // use () to import jQuery
import { EditorView, lineNumbers, keymap } from "@codemirror/view";
import { EditorState } from "@codemirror/state";
import { history, defaultKeymap, historyKeymap } from '@codemirror/commands';
import { StreamLanguage, syntaxHighlighting, defaultHighlightStyle } from "@codemirror/language";
import { shell } from '@codemirror/legacy-modes/mode/shell';
import "@fortawesome/fontawesome-free/js/all";

import("./bootstrap-fileupload"); // use () to import $

window.editorFromTextArea = function (textarea, options) {
  let extensions = [
    history(),
    keymap.of(defaultKeymap),
    keymap.of(historyKeymap),
    StreamLanguage.define(shell),
    syntaxHighlighting(defaultHighlightStyle)
  ];
  if (options.firstLineNumber) {
    extensions.push(lineNumbers(
      { formatNumber: (n) => (n + options.firstLineNumber - 1).toString() }
    ));
  } else {
    extensions.push(lineNumbers());
  }
  if (options.readOnly) {
    extensions.push(EditorState.readOnly.of(true));
  }

  const view = new EditorView({doc: textarea.value, extensions});
  textarea.parentNode.insertBefore(view.dom, textarea);
  textarea.style.display = "none";
  if (textarea.form) {
    textarea.form.addEventListener("submit", () => {
      textarea.value = view.state.doc.toString();
    });
  }
  return view;
}
