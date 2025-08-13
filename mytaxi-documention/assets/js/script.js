/*!
 * Documenter 2.0
 * http://rxa.li/documenter
 *
 * Copyright 2011, Xaver Birsak
 * http://revaxarts.com
 */
$(document).ready(function() {
    var timeout,
        sections = [],
        sectionscount = 0,
        win = $(window),
        sidebar = $('#documenter_sidebar'),
        nav = $('#documenter_nav'),
        logo = $('#documenter_logo'),
        navanchors = nav.find('a'),
        timeoffset = 50,
        hash = location.hash || null,
        iDeviceNotOS4 = (navigator.userAgent.match(/iphone|ipod|ipad/i) && !navigator.userAgent.match(/OS 5/i)) || false,
        badIE = $('html').prop('class').match(/ie(6|7|8)/) || false;

    // Handle external links (open in new window)
    $('a[href^=http]').on('click', function() {
        window.open($(this).attr('href'));
        return false;
    });

    // Initialize sections array
    function updateSections() {
        sections = [];
        var sectionselector = nav.find('ol').length ? 'section, h4' : 'section';
        $(sectionselector).each(function(i, e) {
            var _this = $(this);
            var p = {
                id: this.id,
                pos: _this.offset().top
            };
            sections.push(p);
        });
        sectionscount = sections.length;
    }

    // Handle smooth scrolling for non-IE browsers
    if (!badIE) {
        window.scrollTo(0, 0);
        $('a[href^=#]').on('click touchstart', function() {
            hash = $(this).attr('href');
            $.scrollTo.window().queue([]).stop();
            goTo(hash);
            return false;
        });

        // Go to hash on page load
        if (hash) {
            setTimeout(function() {
                goTo(hash);
            }, 500);
        }
    }

    // Update sections on load and resize
    win.on('load resize', function() {
        updateSections();
    });

    // Handle scroll event
    win.on('scroll', function() {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            // Update sections to account for dynamic content
            updateSections();
            var pos = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;

            // Handle iDeviceNotOS4
            if (iDeviceNotOS4) {
                sidebar.css({ height: document.height });
                logo.css({ 'margin-top': pos });
            }

            // Activate nav element at current position
            activateNav(pos);
        }, timeoffset);
    }).trigger('scroll');

    // Handle iDeviceNotOS4 click events
    if (iDeviceNotOS4) {
        nav.find('a').on('click', function() {
            setTimeout(function() {
                win.trigger('scroll');
            }, 500); // Match duration
        });
        window.scrollTo(0, 0);
    }

    // Scroll to section and update hash
    function goTo(hash, changehash = true) {
        win.off('hashchange');
        hash = hash.replace(/!\//, '');
        var target = $(hash);
        if (target.length) {
            win.stop().scrollTo(target, 500, {
                easing: 'swing',
                axis: 'y'
            });
            if (changehash) {
                var l = location;
                location.href = (l.protocol + '//' + l.host + l.pathname + '#' + hash.substr(1));
            }
        }
        win.on('hashchange', hashchange);
    }

    // Handle hash change
    function hashchange() {
        goTo(location.hash, false);
    }

    // Activate current nav element
    function activateNav(pos) {
        var offset = 50; // Reduced offset for more precise activation
        win.off('hashchange');
        let currentSection = null;

        // Find the current section
        for (let i = 0; i < sectionscount; i++) {
            if (sections[i].pos <= pos + offset) {
                currentSection = sections[i];
            } else {
                break;
            }
        }

        if (currentSection) {
            navanchors.removeClass('current');
            var current = navanchors.filter(`[href="#${currentSection.id}"]`);
            if (current.length) {
                current.addClass('current');
                var parent = current.parent().parent();
                var next = current.next();
                var hasSub = next.is('ul');
                var isSub = !parent.is('#documenter_nav');

                nav.find('ol:visible').not(parent).slideUp('fast');
                if (isSub) {
                    parent.prev().addClass('current');
                    parent.stop().slideDown('fast');
                } else if (hasSub) {
                    next.stop().slideDown('fast');
                }
            }
        }
        win.on('hashchange', hashchange);
    }

    // Make code pretty
    window.prettyPrint && prettyPrint();
});