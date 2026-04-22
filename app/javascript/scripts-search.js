import { editorFromTextArea } from "./codemirror";

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".script-area").forEach((el) => {
    const firstLineNumber = el.dataset.firstLineNumber;
    editorFromTextArea(el, {
      readOnly: true,
      firstLineNumber: firstLineNumber,
    });
  });
});
