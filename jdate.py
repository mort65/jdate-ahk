#!/usr/bin/python3

import datetime

jMonth = [
    "Farvardin",
    "Ordibehesht",
    "Khordad",
    "Tir",
    "Mordad",
    "Shahrivar",
    "Mehr",
    "Aban",
    "Azar",
    "Day",
    "Bahman",
    "Esfand",
]

gMonth = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
]

jWeek = [
    "Doshanbe",
    "Seshanbe",
    "Chaharshanbe",
    "Panjshanbe",
    "Jom-e",
    "Shanbe",
    "Yekshanbe",
]

gWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]


def gregorian_to_jalali(gd, gm, gy):
    # converts gregorian date to jalali
    if not gy or not gm or not gd:
        raise ValueError
    g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
    gy2 = (gy + 1) if (gm > 2) else gy
    days = (
        355666
        + (365 * gy)
        + (((gy2 + 3) // 4))
        - (((gy2 + 99) // 100))
        + (((gy2 + 399) // 400))
        + gd
        + g_d_m[gm - 1]
    )
    jy = -1595 + (33 * ((days // 12053)))
    days %= 12053
    jy += 4 * ((days // 1461))
    days %= 1461
    if days > 365:
        jy += (days - 1) // 365
        days = (days - 1) % 365
    jm = (1 + (days // 31)) if (days < 186) else (7 + ((days - 186) // 30))
    jd = 1 + ((days % 31) if (days < 186) else ((days - 186) % 30))
    return [jd, jm, jy]


def jalali_to_gregorian(jd, jm, jy):
    # converts jalali date to gregorian
    if not jy or not jm or not jd:
        raise ValueError
    jy += 1595
    days = (
        -355668
        + (365 * jy)
        + (((jy // 33)) * 8)
        + (((jy % 33) + 3) // 4)
        + jd
        + ((jm - 1) * 31 if (jm < 7) else ((jm - 7) * 30) + 186)
    )

    gy = 400 * ((days // 146097))
    days = days % 146097
    if days > 36524:
        gy += 100 * ((--days // 36524))
        days = days % 36524
        if days >= 365:
            days += 1
    gy += 4 * ((days // 1461))
    days = days % 1461
    if days > 365:
        gy += (days - 1) // 365
        days = (days - 1) % 365
    gd = days + 1
    sal_a = [
        0,
        31,
        29 if (((gy % 4) == 0 and (gy % 100) != 0) or ((gy % 400) == 0)) else 28,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31,
    ]
    gm = 0
    while gm < 13 and gd > sal_a[gm]:
        gd -= sal_a[gm]
        gm += 1
    return [gd - 1, gm, gy]


def gToday():
    gDate = datetime.datetime.today()
    return [gDate.day, gDate.month, gDate.year]


def jToday():
    gDate = gToday()
    return gregorian_to_jalali(gDate[0], gDate[1], gDate[2])


def weekDay():
    return datetime.datetime.today().weekday()


def formatDate(date):
    if not (type(date) == list and len(date) > 2):
        raise ValueError
    else:
        return "{0:0=4d}/{1:0=2d}/{2:0=2d}".format(date[2], date[1], date[0])


def jFormatToday():
    date = jToday()
    return "{0:0=4d} {1} {2} {3:0=2d}".format(
        date[2], jWeek[weekDay()][:3], jMonth[date[1] - 1][:3], date[0]
    )


def gFormatToday():
    date = gToday()
    return "{0:0=4d} {1} {2} {3:0=2d}".format(
        date[2], gWeek[weekDay()][:3], gMonth[date[1] - 1][:3], date[0]
    )


# print(gregorian_to_jalali(6,9,2023))
# print(jalali_to_gregorian(1,4,1402))
# print(gToday())
# print(jToday())
# print(formatDate(gToday()))
print(jFormatToday())
