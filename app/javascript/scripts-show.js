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
  let lastSeenId = null;

  function showLoadingIndicator() {
    document.getElementById("logs-loading").classList.remove("d-none");
  }

  function hideLoadingIndicator() {
    document.getElementById("logs-loading").classList.add("d-none");
  }

  function buildRow(log) {
    const tr = document.createElement("tr");
    tr.id = `log-${log.id}`;
    tr.className = log.highlighted ? "logs table-success" : "logs";

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
    return tr;
  }

  function updateLastSeenId(logs) {
    if (logs.length > 0) lastSeenId = logs[0].id;
  }

  function renderTableRows(data, delta) {
    const tbody = document.getElementById("logs-tbody");
    if (delta && data.logs.length === 0) {
      hideLoadingIndicator();
      return;
    }
    const fragment = document.createDocumentFragment();
    data.logs.forEach((log) => {
      fragment.appendChild(buildRow(log));
    });
    if (delta) {
      tbody.insertBefore(fragment, tbody.firstChild);
    } else {
      tbody.innerHTML = "";
      tbody.appendChild(fragment);
    }
    document.getElementById("logs-count").textContent = data.count;
    hideLoadingIndicator();
  }

  function fetchLogs(keyword, { delta = false } = {}) {
    showLoadingIndicator();
    const url = new URL(logsUrl, window.location.origin);
    if (keyword) {
      url.searchParams.set("keyword", keyword);
    }
    const isDelta = delta && lastSeenId !== null;
    if (isDelta) {
      url.searchParams.set("since_id", lastSeenId);
    }
    fetch(url.toString(), { headers: { Accept: "application/json" } })
      .then((response) => {
        if (!response.ok) throw new Error("error");
        return response.json();
      })
      .then((data) => {
        updateLastSeenId(data.logs);
        renderTableRows(data, isDelta);
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
        lastSeenId = null;
        fetchLogs(keyword);
      }
    });
  }

  setInterval(() => {
    const autoReload = document.getElementById("logs_auto_reload");
    if (autoReload?.checked) {
      fetchLogs(keywordInput ? keywordInput.value : "", { delta: true });
    }
  }, 15 * 1000);
});
