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
        updateFullCalendar: updateFullCalendar
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
