//dark version
const body = document.body;
const sunIcon = document.querySelector('.las.la-sun');
const moonIcon = document.querySelector('.las.la-moon');

$(document).on('click', '.header-version-bar', function () {
    $('body').toggleClass('dark');
});

$(document).on('click', '.header-version-bar', function() {
    setVersion(localStorage.getItem('page-wrapper'));
});

if (localStorage.getItem('page-wrapper') == 'light-version') {
    localStorage.setItem('page-wrapper', 'dark');
} else {
    localStorage.setItem('page-wrapper', 'light-version');
}

setVersion(localStorage.getItem('page-wrapper'));

function setVersion(version) {
    if (version == 'dark') {
        localStorage.setItem('page-wrapper', 'light-version');
        $('body').addClass(version);
        $('.sidebar-main-logo img').attr('src', $('.sidebar-main-logo img').data('dark_img'));
        sunIcon.style.display = 'none';
        moonIcon.style.display = 'inline';

    } else {
        localStorage.setItem('page-wrapper', 'dark');
        $('body').removeClass('dark');
        if(localStorage.getItem('sidebar-theme') == 'dark-sidebar') {
        $('.sidebar-main-logo img').attr('src', $('.sidebar-main-logo img').data('dark_img'));
        }else {
        $('.sidebar-main-logo img').attr('src', $('.sidebar-main-logo img').data('white_img'));
        }
        sunIcon.style.display = 'inline';
        moonIcon.style.display = 'none';
    }
}
