// Source: https://reddit.com/r/youtube/comments/12gnh5f/comment/jqj5sw9
setInterval(() => {
  let select = document.querySelectorAll(
    "button yt-icon.style-scope.ytd-menu-renderer"
  );
  select[2].click();

  let its = document.querySelectorAll(
    "tp-yt-paper-item.style-scope.ytd-menu-service-item-renderer"
  );
  its[2].click();
}, 500);
