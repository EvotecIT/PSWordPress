<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSWordPress"><img src="https://img.shields.io/powershellgallery/v/PSWordPress.svg?style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/PSWordPress"><img src="https://img.shields.io/powershellgallery/vpre/PSWordPress.svg?label=powershell%20gallery%20preview&colorB=yellow&style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PSWordPress"><img src="https://img.shields.io/github/license/EvotecIT/PSWordPress.svg?style=flat-square"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSWordPress"><img src="https://img.shields.io/powershellgallery/p/PSWordPress.svg?style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PSWordPress"><img src="https://img.shields.io/github/languages/top/evotecit/PSWordPress.svg?style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PSWordPress"><img src="https://img.shields.io/github/languages/code-size/evotecit/PSWordPress.svg?style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/PSWordPress"><img src="https://img.shields.io/powershellgallery/dt/PSWordPress.svg?style=flat-square"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=flat-square"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg?style=flat-square"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn&style=flat-square"></a>
</p>

# PSWordPress - PowerShell Module

**PSWordPress** is PowerShell Module that allows interacting with WordPress using PowerShell via Rest API. It allows to **list**, **create**, **edit** or **remove** posts, pages, etc.

## Documentation - Development

PSWordPress uses Wordpress API. I've added minimal amount of cmdlets that I need for myself. Feel free to create issues or PRs when needing something more.

- [x] [Wordpress Rest API](https://developer.wordpress.org/rest-api/)
- [X] [Wordpress API](https://developer.wordpress.com/docs/api/)

## Installation

### Option 1

By default WordPress since version 5.6 allows application passwords to be used to for accounts (make sure to have it enabled in Wordfence, as it blocks it by default).

- Generate Application Password
    - Go the **User Profile** page of the user that you want to **generate a new application password** for.
    - To do so, **click Users** on the left side of the **WordPress admin**, then click on the user that you want to manage.
    - Scroll down until you see the **Application Passwords** section. This is typically at the bottom of the page.
    - Within the input field, type in a name for your **new application password**, then click Add New.
    - Note: The application password name is only used to describe your password for easy management later. It will not affect your password    in any way. Be descriptive, as it will lead to easier management if you ever need to change it later.
    - Once the Add New button is clicked, your **new application password** will appear. Be sure to keep this somewhere safe, as it will not    be displayed to you again. If you lose this password, it cannot be obtained again.
- Install this PowerShell module

```powershell
Install-Module PSWordPress -Force
```

### Option 2

If you have older version of WordPress or preffer using Basic Authentication method it can be used using following plugin

- Install [WP API SwaggerUI Wordpress Plugin](https://wordpress.org/plugins/wp-api-swaggerui/) to allow WordPress API via Basic Authentication
    - Your login and password are the same as any user you create in WordPress
    - Feel free to create new user with proper role rights that works with RestAPI
- Install this PowerShell module

```powershell
Install-Module PSWordPress -Force
```

### Option 3

Alternatively if you have older version of WordPress, you can use application passwords plugin. Keep in mind this method works as the one from option 1, just thru plugin.

- Install [Application Passwords Wordpress Plugin](https://wordpress.org/plugins/application-passwords/)
    - Go the **User Profile** page of the user that you want to **generate a new application password** for.
    - To do so, **click Users** on the left side of the **WordPress admin**, then click on the user that you want to manage.
    - Scroll down until you see the **Application Passwords** section. This is typically at the bottom of the page.
    - Within the input field, type in a name for your **new application password**, then click Add New.
    - Note: The application password name is only used to describe your password for easy management later. It will not affect your password    in any way. Be descriptive, as it will lead to easier management if you ever need to change it later.
    - Once the Add New button is clicked, your **new application password** will appear. Be sure to keep this somewhere safe, as it will not    be displayed to you again. If you lose this password, it cannot be obtained again.
- Install this PowerShell module

```powershell
Install-Module PSWordPress -Force
```

## Usage

Using this PowerShell module requires having UserName and Password. You can provide UserName and Password directly to `Connect-WordPress` using proper properties or you can convert them to e

### Preparing credentials

```powershell

# Prepare secure string
$password = ConvertTo-SecureString -String "PasswordFromWordpressUser or Application Password depending on which plugin is in use" -AsPlainText -Force
$password | ConvertFrom-SecureString | Set-Clipboard

# Build credentials object for automation or simply do Get-Credential
# take the string from above (should be in clipboard) and insert it into next lines
$SecurePassword = ConvertTo-SecureString -String '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000b097b77a31ba66459ff93f9d4c6ff7230000000002000000000003660000c000000010000000a73395656a769b97f78cb9325ea6b84b0000000004800000a000000010000000b454d82939445c8382d57c049daf6c0e380000000a54f7fe5c0698eb4c2e24eca177803e0ef55a4f7da08d8049a5c0833a5751466a341a5312ec69e48d4bc072f97e5bade35d8d974bfe605f140000004c8d273e496d4ef468a3d6d8dff51cd5971b2dd0'
$Credentials = [System.Management.Automation.PSCredential]::new('PowerShell', $SecurePassword)

# Alternatively
$Credentials = Get-Credential -UserName 'PowerShell'
```

### Get WordPress posts

```powershell
# Build credentials object for automation or simply do Get-Credential
$SecurePassword = ConvertTo-SecureString -String '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000b097b77a31ba66459ff93f9d4c6ff7230000000002000000000003660000c000000010000000a538851b69af1543cfcf67bb78e4ed990000000004800000a000000010000000e8b1946cd7316a6668efc759385d03a7400000005b730cc9cbb1ab2c1fda426e71b2cfd68c6b66ec0f1fb895f0af132df3feddd6494237064bc7469d0ccc34655c579585c88f376c702ffbfeba0eea53d7bfa36c14000000f20d8b0686321544ff2ca62f21fc8c28fa86c672'
$Credentials = [System.Management.Automation.PSCredential]::new('PowerShell', $SecurePassword)

# Authorize to Wordpress
$Authorization = Connect-Wordpress -Credential $Credentials -Url 'https://evotec.xyz/'

# List posts (default 10) with specifc tags
$List = Get-WordPressPost -Authorization $Authorization -Verbose
$List | Format-Table
```

More how-to shown in [Examples](https://github.com/EvotecIT/PSWordPress/tree/master/Examples) folder.
