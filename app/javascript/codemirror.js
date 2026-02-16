import { defaultKeymap, history, historyKeymap } from "@codemirror/commands";
import {
  defaultHighlightStyle,
  StreamLanguage,
  syntaxHighlighting,
} from "@codemirror/language";
import { shell } from "@codemirror/legacy-modes/mode/shell";
import { EditorState } from "@codemirror/state";
import { EditorView, keymap, lineNumbers } from "@codemirror/view";

export const editorFromTextArea = (textarea, options) => {
  const extensions = [
    history(),
    keymap.of(defaultKeymap),
    keymap.of(historyKeymap),
    StreamLanguage.define(shell),
    syntaxHighlighting(defaultHighlightStyle),
  ];
  if (options.firstLineNumber) {
    extensions.push(
      lineNumbers({
        formatNumber: (n) => (n + options.firstLineNumber - 1).toString(),
      }),
    );
  } else {
    extensions.push(lineNumbers());
  }
  if (options.readOnly) {
    extensions.push(EditorState.readOnly.of(true));
  }

  const view = new EditorView({ doc: textarea.value, extensions });
  textarea.parentNode.insertBefore(view.dom, textarea);
  textarea.style.display = "none";
  if (textarea.form) {
    textarea.form.addEventListener("submit", () => {
      textarea.value = view.state.doc.toString();
    });
  }
  return view;
};
