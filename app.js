const state = {
  entries: [],
  selected: null,
};

const elements = {
  dateLabel: document.querySelector("#dateLabel"),
  lineText: document.querySelector("#lineText"),
  statusText: document.querySelector("#statusText"),
  dailyImage: document.querySelector("#dailyImage"),
  archiveList: document.querySelector("#archiveList"),
};

function todayInSeoul() {
  const formatter = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Seoul",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });

  return formatter.format(new Date());
}

function dateLabel(date) {
  return new Intl.DateTimeFormat("ko-KR", {
    timeZone: "Asia/Seoul",
    year: "numeric",
    month: "long",
    day: "numeric",
    weekday: "long",
  }).format(new Date(`${date}T00:00:00+09:00`));
}

function pickInitialEntry(entries) {
  const today = todayInSeoul();
  return entries.find((entry) => entry.date === today) ?? entries[0] ?? null;
}

function renderEntry(entry) {
  state.selected = entry;

  if (!entry) {
    elements.dateLabel.textContent = "아직 응원이 없습니다";
    elements.lineText.textContent = "첫 응원이 쌓이면 이 자리에 보여드릴게요.";
    elements.statusText.textContent =
      "outputs/YYYY-MM-DD 폴더에 line.txt와 image.png를 넣은 뒤 manifest.json을 갱신해 주세요.";
    elements.dailyImage.removeAttribute("src");
    elements.dailyImage.alt = "";
    return;
  }

  const isToday = entry.date === todayInSeoul();
  elements.dateLabel.textContent = isToday
    ? `오늘의 응원 · ${dateLabel(entry.date)}`
    : `가장 최근 응원 · ${dateLabel(entry.date)}`;
  elements.lineText.textContent = entry.line;
  elements.statusText.textContent = isToday
    ? "오늘 아침에 도착한 글과 그림입니다."
    : "오늘 파일이 아직 없어서 가장 최근 응원을 먼저 보여드립니다.";
  elements.dailyImage.src = entry.image;
  elements.dailyImage.alt = `${entry.date} 응원 그림`;

  renderArchive();
}

function renderArchive() {
  elements.archiveList.replaceChildren(
    ...state.entries.map((entry) => {
      const button = document.createElement("button");
      const date = document.createElement("strong");
      const line = document.createElement("span");

      button.className = "archive-button";
      button.type = "button";
      button.setAttribute("aria-pressed", String(entry === state.selected));
      date.textContent = entry.date;
      line.textContent = entry.line;
      button.append(date, line);
      button.addEventListener("click", () => renderEntry(entry));
      return button;
    }),
  );
}

async function load() {
  try {
    const response = await fetch("./manifest.json", { cache: "no-store" });
    if (!response.ok) {
      throw new Error(`manifest ${response.status}`);
    }

    const manifest = await response.json();
    state.entries = [...(manifest.entries ?? [])].sort((a, b) =>
      b.date.localeCompare(a.date),
    );
    renderEntry(pickInitialEntry(state.entries));
  } catch (error) {
    console.error(error);
    renderEntry(null);
  }
}

load();
