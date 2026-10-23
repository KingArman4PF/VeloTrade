(function () {
  // Mobile sidebar toggle
  var toggle = document.querySelector('.menu-toggle');
  var sidebar = document.querySelector('.sidebar');
  if (toggle && sidebar) {
    toggle.addEventListener('click', function () {
      sidebar.classList.toggle('open');
    });
    document.addEventListener('click', function (e) {
      if (sidebar.classList.contains('open') &&
          !sidebar.contains(e.target) &&
          !toggle.contains(e.target)) {
        sidebar.classList.remove('open');
      }
    });
  }

  // Live clock in the topbar
  var clockEl = document.getElementById('liveClock');
  if (clockEl) {
    var update = function () {
      var now = new Date();
      var h = String(now.getHours()).padStart(2, '0');
      var m = String(now.getMinutes()).padStart(2, '0');
      var s = String(now.getSeconds()).padStart(2, '0');
      clockEl.textContent = h + ':' + m + ':' + s;
    };
    update();
    setInterval(update, 1000);
  }

  // Searchable symbol combobox — now backed by Twelve Data's live symbol
  // search instead of the static VT_SYMBOLS list. Falls back to the local
  // list automatically if the live request fails (offline, key not set,
  // rate limited, etc.) so the field never just goes dead.
  window.vtInitSymbolCombo = function (inputId, listId) {
    var input = document.getElementById(inputId);
    var list = document.getElementById(listId);
    if (!input || !list) return;

    var debounceTimer = null;
    var requestSeq = 0;

    function friendlyType(instrumentType) {
      if (instrumentType === 'Physical Currency') return 'Forex';
      if (instrumentType === 'Digital Currency') return 'Crypto';
      if (instrumentType === 'Common Stock') return 'Stock';
      return instrumentType || '';
    }

    function renderResults(items) {
      list.innerHTML = '';
      if (!items.length) { list.classList.remove('open'); return; }

      items.forEach(function (item) {
        var el = document.createElement('div');
        el.className = 'combo-item';
        el.innerHTML =
          '<span class="combo-symbol">' + item.symbol + '</span>' +
          '<span class="combo-name">' + item.name + '</span>' +
          '<span class="combo-tag">' + item.category + '</span>';
        el.addEventListener('mousedown', function (e) {
          e.preventDefault();
          // Store the compact form (EURUSD, not EUR/USD) to stay consistent
          // with how the rest of VeloTrade stores and matches symbols.
          input.value = item.symbol.replace('/', '');
          list.classList.remove('open');
          input.dispatchEvent(new Event('change'));
        });
        list.appendChild(el);
      });
      list.classList.add('open');
    }

    function renderFromStaticList(filterText) {
      if (typeof VT_SYMBOLS === 'undefined') { list.classList.remove('open'); return; }
      var f = filterText.trim().toUpperCase();
      var matches = VT_SYMBOLS.filter(function (s) {
        return !f || s.symbol.indexOf(f) !== -1 || s.name.toUpperCase().indexOf(f) !== -1;
      }).slice(0, 40);
      renderResults(matches.map(function (s) {
        return { symbol: s.symbol, name: s.name, category: s.category };
      }));
    }

    function search(filterText) {
      var text = filterText.trim();
      if (!text) { list.classList.remove('open'); return; }

      var seq = ++requestSeq;
      fetch('SymbolSearch.ashx?q=' + encodeURIComponent(text))
        .then(function (r) { return r.json(); })
        .then(function (data) {
          if (seq !== requestSeq) return; // a newer keystroke already superseded this
          if (data.error || !data.data) { renderFromStaticList(text); return; }
          var items = data.data.slice(0, 40).map(function (d) {
            return { symbol: d.symbol, name: d.instrument_name, category: friendlyType(d.instrument_type) };
          });
          renderResults(items);
        })
        .catch(function () {
          if (seq === requestSeq) renderFromStaticList(text);
        });
    }

    input.addEventListener('input', function () {
      clearTimeout(debounceTimer);
      var text = input.value;
      debounceTimer = setTimeout(function () { search(text); }, 300);
    });
    input.addEventListener('focus', function () { search(input.value); });
    document.addEventListener('click', function (e) {
      if (e.target !== input && !list.contains(e.target)) {
        list.classList.remove('open');
      }
    });
  };
})();
