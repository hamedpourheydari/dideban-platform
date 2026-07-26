(function (window, $) {
    'use strict';

    var persianDigits = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];

    var persianMonths = [
        'فروردین',
        'اردیبهشت',
        'خرداد',
        'تیر',
        'مرداد',
        'شهریور',
        'مهر',
        'آبان',
        'آذر',
        'دی',
        'بهمن',
        'اسفند'
    ];

    function toPersianDigits(value) {
        return String(value).replace(/\d/g, function (digit) {
            return persianDigits[Number(digit)];
        });
    }

    function toEnglishDigits(value) {
        return String(value)
            .replace(/[۰-۹]/g, function (digit) {
                return String(persianDigits.indexOf(digit));
            })
            .replace(/[٠-٩]/g, function (digit) {
                return String('٠١٢٣٤٥٦٧٨٩'.indexOf(digit));
            });
    }

    function normalizeDate(value) {
        if (!value) {
            return null;
        }

        if (value instanceof Date) {
            return new Date(value.getTime());
        }

        if (typeof value.toDate === 'function') {
            return value.toDate();
        }

        if (typeof value === 'string') {
            var dateOnlyMatch = value.match(/^(\d{4})-(\d{2})-(\d{2})$/);

            if (dateOnlyMatch) {
                return new Date(
                    Number(dateOnlyMatch[1]),
                    Number(dateOnlyMatch[2]) - 1,
                    Number(dateOnlyMatch[3]),
                    12,
                    0,
                    0
                );
            }
        }

        var date = new Date(value);

        return isNaN(date.getTime()) ? null : date;
    }

    function getPersianParts(value) {
        var date = normalizeDate(value);

        if (!date) {
            return null;
        }

        var formatter = new Intl.DateTimeFormat(
            'fa-IR-u-ca-persian-nu-latn',
            {
                year: 'numeric',
                month: 'numeric',
                day: 'numeric'
            }
        );

        var parts = formatter.formatToParts(date);
        var result = {};

        parts.forEach(function (part) {
            if (
                part.type === 'year' ||
                part.type === 'month' ||
                part.type === 'day'
            ) {
                result[part.type] = Number(part.value);
            }
        });

        if (!result.year || !result.month || !result.day) {
            return null;
        }

        return result;
    }

    function pad(value) {
        return String(value).padStart(2, '0');
    }

    function dateOnly(value, usePersianDigits) {
        var parts = getPersianParts(value);

        if (!parts) {
            return '';
        }

        var output =
            parts.year + '/' +
            pad(parts.month) + '/' +
            pad(parts.day);

        return usePersianDigits === false
            ? output
            : toPersianDigits(output);
    }

    function dayNumber(value, usePersianDigits) {
        var parts = getPersianParts(value);

        if (!parts) {
            return '';
        }

        return usePersianDigits === false
            ? String(parts.day)
            : toPersianDigits(parts.day);
    }

    function monthTitle(value, usePersianDigits) {
        var parts = getPersianParts(value);

        if (!parts) {
            return '';
        }

        var output =
            persianMonths[parts.month - 1] +
            ' ' +
            parts.year;

        return usePersianDigits === false
            ? output
            : toPersianDigits(output);
    }

    function dateTime(value, usePersianDigits) {
        var date = normalizeDate(value);

        if (!date) {
            return '';
        }

        var output =
            dateOnly(date, false) +
            ' ' +
            pad(date.getHours()) + ':' +
            pad(date.getMinutes()) + ':' +
            pad(date.getSeconds());

        return usePersianDigits === false
            ? output
            : toPersianDigits(output);
    }

    function formatHeader(value, usePersianDigits) {
        var date = normalizeDate(value || new Date());

        if (!date) {
            return '';
        }

        var output = new Intl.DateTimeFormat(
            'fa-IR-u-ca-persian-nu-latn',
            {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            }
        ).format(date);

        return usePersianDigits === false
            ? output
            : toPersianDigits(output);
    }

    function formatTime(value, usePersianDigits) {
        var date = normalizeDate(value || new Date());

        if (!date) {
            return '';
        }

        var output =
            pad(date.getHours()) + ':' +
            pad(date.getMinutes()) + ':' +
            pad(date.getSeconds());

        return usePersianDigits === false
            ? output
            : toPersianDigits(output);
    }

    function isEnglishHeaderDate(value) {
        return /^(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday)\s+\d{1,2}\s+(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4}$/.test(value);
    }

    function isHeaderClock(value) {
        return /^[۰-۹\d]{1,2}\s*:\s*[۰-۹\d]{2}\s*:\s*[۰-۹\d]{2}$/.test(value);
    }

    function findHeaderElements() {
        var $scope = $('#main_header');

        if (!$scope.length) {
            $scope = $('body');
        }

        if (!$('[data-dideban-header-date="1"]').length) {
            $scope.find('*').filter(function () {
                return this.children.length === 0 &&
                    isEnglishHeaderDate($.trim($(this).text()));
            }).first().attr('data-dideban-header-date', '1');
        }

        if (!$('[data-dideban-header-time="1"]').length) {
            $scope.find('*').filter(function () {
                return this.children.length === 0 &&
                    isHeaderClock($.trim($(this).text()));
            }).first().attr('data-dideban-header-time', '1');
        }
    }

    function updateDashboardHeader() {
        findHeaderElements();

        var now = new Date();
        var $date = $('[data-dideban-header-date="1"]');
        var $time = $('[data-dideban-header-time="1"]');

        if ($date.length) {
            $date
                .text(formatHeader(now))
                .attr('dir', 'rtl');
        }

        if ($time.length) {
            $time
                .text(formatTime(now))
                .attr('dir', 'ltr');
        }
    }

    function calendarTitle(view) {
        if (!view) {
            return '';
        }

        var viewName = view.name || '';
        var start = view.intervalStart || view.start;
        var end = view.intervalEnd || view.end;

        if (!start) {
            return '';
        }

        if (viewName === 'month') {
            var middleDate = normalizeDate(start);

            if (end) {
                var endDate = normalizeDate(end);

                if (middleDate && endDate) {
                    middleDate = new Date(
                        (middleDate.getTime() + endDate.getTime()) / 2
                    );
                }
            }

            return monthTitle(middleDate);
        }

        if (
            viewName === 'agendaWeek' ||
            viewName === 'listWeek'
        ) {
            var weekStart = normalizeDate(view.start);
            var weekEnd = normalizeDate(view.end);

            if (!weekStart || !weekEnd) {
                return monthTitle(start);
            }

            weekEnd.setDate(weekEnd.getDate() - 1);

            return (
                dateOnly(weekStart) +
                ' تا ' +
                dateOnly(weekEnd)
            );
        }

        if (viewName === 'agendaDay') {
            return dateOnly(start);
        }

        return monthTitle(start);
    }

    function updateCalendarTitle($calendar, view) {
        var title = calendarTitle(view);

        if (title) {
            $calendar.find('.fc-center h2').text(title);
        }
    }

    function updateCalendarDays($calendar) {
        $calendar
            .find('.fc-day-top[data-date]')
            .each(function () {
                var $cell = $(this);
                var gregorianDate = $cell.attr('data-date');
                var jalaliDay = dayNumber(gregorianDate);

                $cell
                    .find('.fc-day-number')
                    .text(jalaliDay);
            });

        $calendar
            .find('.fc-day-number[data-date]')
            .each(function () {
                var $element = $(this);
                var gregorianDate = $element.attr('data-date');

                $element.text(dayNumber(gregorianDate));
            });
    }

    function updateFullCalendar($calendar, view) {
        if (!$calendar || !$calendar.length) {
            return;
        }

        updateCalendarTitle($calendar, view);
        updateCalendarDays($calendar);
    }


    // Jalali/Gregorian conversion adapted from the public-domain jalaali-js algorithm.
    function div(a, b) { return ~~(a / b); }
    function mod(a, b) { return a - ~~(a / b) * b; }
    function jalCal(jy, withoutLeap) {
        var breaks = [-61,9,38,199,426,686,756,818,1111,1181,1210,1635,2060,2097,2192,2262,2324,2394,2456,3178];
        var bl = breaks.length, gy = jy + 621, leapJ = -14, jp = breaks[0], jm, jump, leap, leapG, march, n, i;
        if (jy < jp || jy >= breaks[bl - 1]) throw new Error('Invalid Jalali year ' + jy);
        for (i = 1; i < bl; i += 1) { jm = breaks[i]; jump = jm - jp; if (jy < jm) break; leapJ = leapJ + div(jump,33)*8 + div(mod(jump,33),4); jp = jm; }
        n = jy - jp; leapJ = leapJ + div(n,33)*8 + div(mod(n,33)+3,4);
        if (mod(jump,33) === 4 && jump - n === 4) leapJ += 1;
        leapG = div(gy,4) - div((div(gy,100)+1)*3,4) - 150;
        march = 20 + leapJ - leapG;
        if (withoutLeap) return {gy:gy,march:march};
        if (jump - n < 6) n = n - jump + div(jump+4,33)*33;
        leap = mod(mod(n+1,33)-1,4); if (leap === -1) leap = 4;
        return {leap:leap,gy:gy,march:march};
    }
    function g2d(gy, gm, gd) { var d = div((gy + div(gm-8,6)+100100)*1461,4) + div(153*mod(gm+9,12)+2,5) + gd - 34840408; d = d - div(div(gy+100100+div(gm-8,6),100)*3,4) + 752; return d; }
    function d2g(jdn) { var j = 4*jdn + 139361631; j = j + div(div(4*jdn+183187720,146097)*3,4)*4 - 3908; var i = div(mod(j,1461),4)*5 + 308; var gd = div(mod(i,153),5)+1; var gm = mod(div(i,153),12)+1; var gy = div(j,1461)-100100+div(8-gm,6); return {gy:gy,gm:gm,gd:gd}; }
    function j2d(jy, jm, jd) { var r = jalCal(jy,true); return g2d(r.gy,3,r.march) + (jm-1)*31 - div(jm,7)*(jm-7) + jd - 1; }
    function d2j(jdn) { var g=d2g(jdn), jy=g.gy-621, r=jalCal(jy,false), jdn1f=g2d(g.gy,3,r.march), k=jdn-jdn1f, jd, jm; if(k>=0){if(k<=185){jm=1+div(k,31);jd=mod(k,31)+1;return {jy:jy,jm:jm,jd:jd};}k-=186;}else{jy-=1;k+=179;if(r.leap===1)k+=1;}jm=7+div(k,30);jd=mod(k,30)+1;return {jy:jy,jm:jm,jd:jd}; }
    function jalaliToGregorian(jy,jm,jd){ return d2g(j2d(Number(jy),Number(jm),Number(jd))); }
    function gregorianToJalali(gy,gm,gd){ return d2j(g2d(Number(gy),Number(gm),Number(gd))); }
    function isJalaliLeap(jy){ return jalCal(Number(jy),false).leap === 0; }

    window.DidebanDate = {
        toPersianDigits: toPersianDigits,
        toEnglishDigits: toEnglishDigits,
        getPersianParts: getPersianParts,
        dateOnly: dateOnly,
        dateTime: dateTime,
        dayNumber: dayNumber,
        monthTitle: monthTitle,
        formatHeader: formatHeader,
        formatTime: formatTime,
        updateDashboardHeader: updateDashboardHeader,
        calendarTitle: calendarTitle,
        updateFullCalendar: updateFullCalendar,
        jalaliToGregorian: jalaliToGregorian,
        gregorianToJalali: gregorianToJalali,
        isJalaliLeap: isJalaliLeap
    };

    $(function () {
        updateDashboardHeader();

        if (window.didebanHeaderClockInterval) {
            clearInterval(window.didebanHeaderClockInterval);
        }

        window.didebanHeaderClockInterval = setInterval(
            updateDashboardHeader,
            1000
        );
    });

})(window, window.jQuery);
