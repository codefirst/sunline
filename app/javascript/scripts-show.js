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

  const container = document.querySelector(".table-container");
  if (!container) return;

  const logsUrl = container.dataset.logsUrl;

  function showLoadingIndicator() {
    document.getElementById("logs-loading").classList.remove("d-none");
  }

  function hideLoadingIndicator() {
    document.getElementById("logs-loading").classList.add("d-none");
  }

  function buildTableRows(data) {
    const tbody = document.getElementById("logs-tbody");
    const fragment = document.createDocumentFragment();

    data.logs.forEach((log) => {
      const tr = document.createElement("tr");
      tr.id = `log-${log.id}`;
      tr.className = data.highlights.includes(log.id)
        ? "logs table-success"
        : "logs";

      const tdHost = document.createElement("td");
      const link = document.createElement("a");
      link.href = log.url;
      link.textContent = log.host;
      tdHost.appendChild(link);

      const tdUploaded = document.createElement("td");
      tdUploaded.textContent = log.uploaded;

      const tdSize = document.createElement("td");
      tdSize.textContent = log.size;

      tr.appendChild(tdHost);
      tr.appendChild(tdUploaded);
      tr.appendChild(tdSize);
      fragment.appendChild(tr);
    });

    tbody.innerHTML = "";
    tbody.appendChild(fragment);
    document.getElementById("logs-count").textContent = data.count;
    hideLoadingIndicator();
  }

  function fetchLogs(keyword) {
    showLoadingIndicator();
    const url = new URL(logsUrl, window.location.origin);
    if (keyword) {
      url.searchParams.set("keyword", keyword);
    }
    fetch(url.toString(), { headers: { Accept: "application/json" } })
      .then((response) => {
        if (!response.ok) throw new Error("error");
        return response.json();
      })
      .then((data) => {
        buildTableRows(data);
      })
      .catch(() => {
        document.getElementById("logs-tbody").innerHTML = "";
        document.getElementById("logs-count").textContent = "0";
        hideLoadingIndicator();
      });
  }

  const keywordInput = document.getElementById("keyword-input");
  fetchLogs(keywordInput ? keywordInput.value : "");

  if (keywordInput) {
    keywordInput.addEventListener("keydown", (e) => {
      if (e.key === "Enter" && !e.isComposing) {
        e.preventDefault();
        const keyword = keywordInput.value;
        const pageUrl = new URL(window.location.href);
        if (keyword) {
          pageUrl.searchParams.set("keyword", keyword);
        } else {
          pageUrl.searchParams.delete("keyword");
        }
        history.replaceState(null, "", pageUrl.toString());
        fetchLogs(keyword);
      }
    });
  }

  setInterval(() => {
    const autoReload = document.getElementById("logs_auto_reload");
    if (autoReload?.checked) {
      fetchLogs(keywordInput ? keywordInput.value : "");
    }
  }, 15 * 1000);
});
