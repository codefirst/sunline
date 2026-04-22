import { editorFromTextArea } from "./codemirror";

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".copy-button").forEach((button) => {
    button.addEventListener("click", (e) => {
      const btn = e.currentTarget;
      const text = btn.dataset.clipboardText;
      navigator.clipboard.writeText(text).then(() => {
        const tooltip = new Tooltip(btn, {
          trigger: "manual",
          title: btn.dataset.copiedText,
        });
        tooltip.show();
        setTimeout(() => {
          tooltip.dispose();
        }, 3000);
      });
    });
  });

  document.querySelectorAll(".script-area").forEach((el) => {
    editorFromTextArea(el, { readOnly: true });
  });

  setInterval(() => {
    const autoReload = document.getElementById("logs_auto_reload");
    if (autoReload?.checked) {
      const url = window.location.href.split("#")[0];
      fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
        .then((response) => {
          if (!response.ok) {
            throw new Error("error");
          }
          return response.text();
        })
        .then((html) => {
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, "text/html");
          const newTable = doc.querySelector("#logs-table");
          const tableContainer = document.querySelector(".table-container");
          if (newTable && tableContainer) {
            const oldTable = tableContainer.querySelector("#logs-table");
            oldTable.replaceWith(newTable);
            const count = newTable.querySelectorAll("tbody tr").length;
            const logsCount = document.getElementById("logs-count");
            logsCount.textContent = count;
          }
        })
        .catch(() => {
          const logsTable = document.getElementById("logs-table");
          logsTable.innerHTML = "";
          const logsCount = document.getElementById("logs-count");
          logsCount.textContent = 0;
        });
    }
  }, 15 * 1000);
});
