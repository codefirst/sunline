import { editorFromTextArea } from "./codemirror";

document.addEventListener("DOMContentLoaded", () => {
  const attachmentMoreButton = document.querySelector(".attachment-more");
  attachmentMoreButton.addEventListener("click", (e) => {
    e.preventDefault();
    const fileinputs = document.querySelector(".fileinputs");
    const fileinput = fileinputs.querySelector(".fileinput:first-child");
    const lastupload = fileinputs.querySelector(".fileinput:last-child");
    const clone = fileinput.cloneNode(true);
    clone.style.display = "";
    lastupload.after(clone);
  });

  document.querySelectorAll(".script-area").forEach((el) => {
    editorFromTextArea(el, {});
  });
});
