
// Called by App to get the WKWebView to filter towns
function filter(searchText) {
    var table = document.getElementById("townTable")
    return filterTowns(table, searchText);
}

// Called by App to clear all town filtering
function clearFilter() {
    unfilterTowns();
}

var lastContainer;
var lastPopulationCount = 0;

// Find all town entries. If they do not match the current filter add the .notFound class to the element
function filterTowns(container,what) {
    
    unfilterTowns();
    
    var count = 0;
    var populationCount = 0;
    
    var townRows = container.getElementsByClassName('townRow');
    var searchExp = new RegExp('^' + what,'i');
    
    for (var i = 0; i < townRows.length; ++i) {
        var towns = townRows[i].getElementsByClassName('town')
        if (towns.length > 0) {
            var town = towns[0]
            var links = town.getElementsByTagName('a');
            if (links.length > 0 ) {
                var text = links[0].innerHTML;
                if (!text.match(searchExp)) {
                    townRows[i].classList.add('notFound')
                } else {
                    var populations = townRows[i].getElementsByClassName('population');
                    if (populations.length > 0) {
                        var population = populations[0];
                        var populationText = population.innerHTML.replace(',','');
                        var populationInt = parseInt(populationText);
                        if (isNaN(populationInt) == false) {
                            populationCount += populationInt;
                        }
                    }
                    count ++
                }
            }
        }
    }
    
    lastContainer = container
    
    if (populationCount != lastPopulationCount) {
        var message = { "population": populationCount }
        webkit.messageHandlers.populationHasChanged.postMessage(message)
    }
    
    lastPopulationCount = populationCount;
    
    return count;
}

// Remove all .notFound css entries.
function unfilterTowns() {
    
    if (lastContainer == null) { return; }
    
    var hiddenTowns = lastContainer.getElementsByClassName('notFound');
    for (var i = 0; i < hiddenTowns.length; ++i) {
        hiddenTowns[i].classList.remove('notFound');
    }
}

// Add the .notFound CSS Style.
var style = document.createElement('style');
style.type = 'text/css';
style.innerHTML = '.notFound { display: none; }';
document.getElementsByTagName('head')[0].appendChild(style);

