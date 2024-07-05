## En-taturial

# SAMP Ban System with Pawno and Database

## Introduction
This tutorial explains how to create a ban system for a SAMP server using Pawno scripting language and a MySQL database. The system allows administrators to ban players and save the ban information in a database.

## Files
- `scripts/ban_system.pwn`: Pawno script for the ban system.
- `db/db.sql`: SQL script to create the necessary database tables.

## Setup Instructions
1. Create the database tables using the `db/db.sql` file.
2. Add the `scripts/ban_system.pwn` script to your SAMP server's `gamemodes` or `filterscripts` folder.
3. Compile the `scripts/ban_system.pwn` script using Pawno.
4. Configure the database connection settings in the script.
5. Run your SAMP server.

## Detailed Script Explanation
### ban_system.pwn
```pawn
#include <a_samp>
#include <a_mysql>

// Define constants
#define MAX_PLAYER_NAME 24

// Declare functions
forward OnPlayerCommandText(playerid, cmdtext[]);

// MySQL connection details
new MySQL:sqlConnection;
new sqlHost[] = "localhost";
new sqlUser[] = "root";
new sqlPass[] = "password";
new sqlDB[]   = "samp_db";

public OnGameModeInit()
{
    // Initialize MySQL connection
    sqlConnection = mysql_connect(sqlHost, sqlUser, sqlPass, sqlDB);
    if(sqlConnection == MYSQL_INVALID_HANDLE)
    {
        print("MySQL connection failed.");
        return 0;
    }
    print("MySQL connection successful.");
    return 1;
}

public OnGameModeExit()
{
    // Close MySQL connection
    mysql_close(sqlConnection);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(sscanf(cmdtext, "/ban %d %s[100]", targetid, reason))
    {
        // Get the player's name
        new name[MAX_PLAYER_NAME];
        GetPlayerName(targetid, name, MAX_PLAYER_NAME);

        // Ban the player
        Ban(targetid);

        // Insert ban record into database
        new query[256];
        format(query, sizeof(query), "INSERT INTO bans (player_name, ban_reason) VALUES ('%s', '%s')", name, reason);
        mysql_query(sqlConnection, query);

        // Notify the admin
        new adminName[MAX_PLAYER_NAME];
        GetPlayerName(playerid, adminName, MAX_PLAYER_NAME);
        new message[128];
        format(message, sizeof(message), "Admin %s banned player %s for: %s", adminName, name, reason);
        SendClientMessageToAll(COLOR_RED, message);

        return 1;
    }
    return 0;
}
```

## IR-taturial

# سیستم بن به همراه فایل های pawn & sql

## معرفی
این آموزش نحوه ایجاد یک سیستم بن برای سرور SAMP با استفاده از زبان برنامه‌نویسی Pawno و پایگاه داده MySQL را توضیح می‌دهد. این سیستم به مدیران اجازه می‌دهد بازیکنان را بن کرده و اطلاعات بن را در پایگاه داده ذخیره کنند.

## فایل‌ها
- `scripts/ban_system.pwn`: اسکریپت Pawno برای سیستم بن.
- `db/db.sql`: اسکریپت SQL برای ایجاد جداول پایگاه داده.

## دستورالعمل‌های راه‌اندازی
1. جداول پایگاه داده را با استفاده از فایل `db/db.sql` ایجاد کنید.
2. اسکریپت `scripts/ban_system.pwn` را به پوشه `gamemodes` یا `filterscripts` سرور SAMP خود اضافه کنید.
3. اسکریپت `scripts/ban_system.pwn` را با استفاده از Pawno کامپایل کنید.
4. تنظیمات اتصال به پایگاه داده را در اسکریپت پیکربندی کنید.
5. سرور SAMP خود را اجرا کنید.

## توضیحات دقیق اسکریپت
### ban_system.pwn

```pawn
#include <a_samp>
#include <a_mysql>

// تعریف ثابت‌ها
#define MAX_PLAYER_NAME 24

// اعلام توابع
forward OnPlayerCommandText(playerid, cmdtext[]);//دیفالت داره ولی اگر نداشت استفاده کنید  pawno این تابع رو گیم مود یا 
// تابع بالا اگر وجود نداشته باشه شما دستوری نمیتونید بزنید و اررور میده بهتون یا به عبارتی تابع وجود نداره 
// جزئیات اتصال MySQL
new MySQL:sqlConnection;
new sqlHost[] = "localhost";
new sqlUser[] = "root";//نام یوزری که ثبت کردین (root دیفالته)
new sqlPass[] = "password";//رمزی که برای یوزر انتخاب کردین (اگر رمزی ندارد درون " " را خالی بزارید)
new sqlDB[]   = "samp_db";//server هست شما هم اینجا بزارید server اسم دیتا بیستون  هرچی بود اینجا میزارید اسم دیتا بیستون فرق داره و حالت دیفالتی نداره پس اگر اسمش 

public OnGameModeInit()
{
    // راه‌اندازی اتصال MySQL
    sqlConnection = mysql_connect(sqlHost, sqlUser, sqlPass, sqlDB);
    if(sqlConnection == MYSQL_INVALID_HANDLE)
    {
        print("Server be data base motasel nashod .");
        return 0;
    }
    print("server be datat base motasel shod .");
    return 1;
}

public OnGameModeExit()
{
    // بستن اتصال MySQL
    mysql_close(sqlConnection);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(sscanf(cmdtext, "/ban %d %s[100]", targetid, reason))
    {
        // دریافت نام بازیکن
        new name[MAX_PLAYER_NAME];
        GetPlayerName(targetid, name, MAX_PLAYER_NAME);

        // بن کردن بازیکن
        Ban(targetid);

        // درج رکورد بن در پایگاه داده
        new query[256];
        format(query, sizeof(query), "INSERT INTO bans (player_name, ban_reason) VALUES ('%s', '%s')", name, reason);
        mysql_query(sqlConnection, query);

        // اطلاع رسانی به ادمین
        new adminName[MAX_PLAYER_NAME];
        GetPlayerName(playerid, adminName, MAX_PLAYER_NAME);
        new message[128];
        format(message, sizeof(message), "admin %s bazikon %s ra ban kard / dalil : %s", adminName, name, reason);
        SendClientMessageToAll(COLOR_RED, message);

        return 1;
    }
    return 0;
}
```
