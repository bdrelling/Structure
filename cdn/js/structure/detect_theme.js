// Source: https://stackoverflow.com/questions/56300132/how-to-override-css-prefers-color-scheme-setting

// If the user has local storage item, apply it.
if (localStorage.getItem('theme')) {
    const storedTheme = localStorage.getItem('theme');
    console.log(`Stored theme: ${storedTheme}`)
    setTheme(storedTheme);
} else {
    watchColorScheme('dark');
    watchColorScheme('light');
}

// After the document loads, ensure we've set the <meta name="theme-color"> tag appropriately.
window.onload = function() {
    setThemeColor()
}

// FUNCTIONS

// Returns the theme set as the data-theme.
function getTheme() {
    return document.documentElement.getAttribute('data-theme')
}

// Toggles the current theme.
function toggleTheme() {
    let currentTheme = getTheme();

    if (currentTheme == 'dark') {
        setTheme('light', true);
    } else {
        setTheme('dark', true);
    }
}

// Set's the theme for the website.
function setTheme(theme, shouldStore = false) {
    console.log(`Setting theme: ${theme}`)

    // Apply the theme as a data attribute.
    document.documentElement.setAttribute('data-theme', theme);
    
    // Set the theme color for supporting browsers.
    setThemeColor();

    // Store the theme, if applicable.
    if (shouldStore) {
        console.log(`Storing theme: ${theme}`);
        localStorage.setItem('theme', theme);
    }
}

// Sets the <meta name="theme-color"> tag content the background color.
function setThemeColor() {
    // Get the intended body background color.
    let backgroundColor = window.getComputedStyle(document.documentElement).getPropertyValue('background-color');

    console.log(`Setting <meta name="theme=color"> tag content to '${backgroundColor}'.`)
    
    // Update the <meta> theme-color attribute to match the theme.
    let themeColorTag = document.querySelector('head meta[name="theme-color"]')
    if (themeColorTag) {
        themeColorTag.setAttribute('content', backgroundColor)
    }
}

// Watches for media color scheme changes.
function watchColorScheme(scheme) {
    // Define the media property we want to listen to.
    let matchMedia = window.matchMedia(`(prefers-color-scheme: ${scheme})`)

    // Listen to changes to our media property.
    matchMedia.addEventListener('change', function (e) {
        // If a theme has been stored, don't trigger a chance when the color scheme changes.
        if (localStorage.getItem('theme')) {
            return
        }
        
        // If the media changes and matches our string, it means a new color scheme is preferred.
        if (e.matches) {
            setTheme(scheme);
        }
    });

    // If this is the detected scheme, set it as the theme immediately upon listening.
    if (matchMedia.matches) {
        setTheme(scheme);
    }
}