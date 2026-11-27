# PC REBIRTH - Maintenance
## Introduction

### Goal
The goal of maintenance and automation in PC REBIRTH is to improve the reliability, security and maintainability of refurbished computers running MX Linux.

### Purpose
Older computers may have limited storage and sytem resources. Regular maintenance helps preserve available dis space and keep installed software up to date.

### Proposed Solution
APT will be used to manage software packages onMX Linux.
A bash maintenance script will combine common maintenance operations int and interactive menu, allowing authorized users to perform maintenance more efficiently and consistently.

## 1. Project Repository Setup
### Objective
Organize the repository to seperate scripts, technical comaprison, documentation and screenshots

### Commands Used
```bash
mkdir scripts comparison documentation screenshots
mkdir screenshots/security screenshots/monitoring screenshots/maintenance

touch INSTALL.md
touch scripts/maintenance.sh
touch comparison/maintenance.md
touch documentation/maintenance.md

ls -R
```

### Command Explanations
- `mkdir` : Creates directories
- `touch` : Creates empty files
- `ls -R` : Displays directories and their contents

### Result
The folders and files were succcessfully created

## 2.Disk Space Management

### Objective
Monitor available disk space on computers to prevent storage-related problems

### Commands Used

```bash
df -h
df -h /
```
### Command Explanations

- `df` : Displays filesystem disk usage
- `-h` : Displays sizes in a human-readable format
- `/` : Specifies the root filesystem

### Implemetation Decision
The comman `df -h /` will be use in the maintenance script to display the main filesystems's storage usage

## 3. Package Cache Management

### Objective 
Remove unnecessary dowloaded package files to preserve available storage on refurbished computers

### Commands Used

```bash
su -
du -sh /var/cache/apt/archives
ls -lh /var/cache/apt/archives
apt clean
du -sh /var/cache/apt/archives
ls -lh /var/cache/apt/archives
exit
```
### Command Explanations
- `su -`: Switches to the root account
- `du -sh` :  Displays the total size of a directory in human-readable format
- `ls -lh` : Displays directory contents and file sizes
- `apt clean` : Removes dowloaded package files from the local package cache
- `exit` : Returns to the regular user account

### Challenge Encountered
`du -sh /var/cache/apt/archives` : I ran this command as regular user but I received a permission denied error. I had to switch to superuser. 

### Implementation Decision
The maintenance script will use `apt clean` to remove unnessary cached package file and dispaly the cache size before and after cleanup.
