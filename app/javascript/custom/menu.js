// ハンバーガーメニューの動作を制御するJavaScript
document.addEventListener('turbo:load', function() {
  // turbo:loadはTurboを使用している場合のイベント
  // Turboを使用していない場合はDOMContentLoadedを使用
  initializeMenu();
});

document.addEventListener('turbo:load', function() {
  initializeMenu();
});

function initializeMenu() {
  const hamburger = document.querySelector('.hamburger-icon');
  const dropdownMenu = document.querySelector('.dropdown-menu');
  
  if (hamburger && dropdownMenu) {
    // クリックでメニューの表示/非表示を切り替え
    hamburger.addEventListener('click', function(e) {
      e.stopPropagation();
      dropdownMenu.classList.toggle('show');
    });
    
    // メニュー以外をクリックした時に閉じる
    document.addEventListener('click', function(e) {
      if (!dropdownMenu.contains(e.target) && !hamburger.contains(e.target)) {
        dropdownMenu.classList.remove('show');
      }
    });
  }
}
