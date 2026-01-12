# OSPOS Development Setup Guide

This guide will help you run the Open Source Point of Sale project locally with **instant CSS/UI updates** that reflect immediately in your browser.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js and npm (already installed)

### Start Development Environment

**Option 1: Using the helper script (Recommended)**
```bash
./dev.sh start
```

**Option 2: Manual setup**
```bash
# 1. Start Docker containers
USERID=$(id -u) GROUPID=$(id -g) docker compose -f docker-compose.dev.yml up -d

# 2. Build initial resources (first time only)
npm run gulp debug-js
npm run gulp debug-css

# 3. Start watching for CSS changes
npm run gulp watch
```

### Access the Application
- **URL:** http://localhost
- **Username:** admin
- **Password:** pointofsale

## 💡 Development Workflow

### Making CSS Changes

1. **Open any CSS file** in `public/css/`:
   - `ospos.css` - Main application styles
   - `invoice.css` - Invoice styles
   - `receipt.css` - Receipt styles
   - `register.css` - Register/POS styles
   - `reports.css` - Report styles
   - etc.

2. **Edit and save** - Changes are automatically detected by Gulp watch

3. **Refresh browser** - Your changes appear immediately!

### How It Works

The development setup uses:
- **Docker volumes** - Your local files are mounted into the container
- **Gulp watch task** - Monitors CSS files for changes
- **Debug mode** - Individual CSS files are loaded (not minified)
- **Development environment** - Error reporting enabled for debugging

### File Structure

```
public/
├── css/                    # ← Edit CSS files here!
│   ├── ospos.css          # Main styles
│   ├── invoice.css        # Invoice styles
│   ├── receipt.css        # Receipt styles
│   └── ...
├── resources/             # ← Auto-generated (don't edit directly)
│   ├── css/              # Processed CSS files
│   └── js/               # Processed JS files
└── index.php             # Application entry point
```

**Important:** 
- ✅ **DO** edit files in `public/css/`
- ❌ **DON'T** edit files in `public/resources/` (auto-generated)

## 🛠️ Helper Commands

### Using dev.sh script:
```bash
./dev.sh start      # Start everything
./dev.sh stop       # Stop containers
./dev.sh restart    # Restart containers
./dev.sh logs       # View application logs
./dev.sh build      # Rebuild CSS/JS resources
./dev.sh db         # Access MySQL database shell
./dev.sh status     # Show container status
```

### Manual commands:
```bash
# Start Gulp watch for CSS changes
npm run gulp watch

# Build debug CSS (development)
npm run gulp debug-css

# Build debug JS (development)
npm run gulp debug-js

# Build production assets (minified)
npm run gulp

# View Docker logs
docker logs -f ospos_dev

# Stop containers
docker compose -f docker-compose.dev.yml down

# Restart containers
docker compose -f docker-compose.dev.yml restart
```

## 🔍 Troubleshooting

### CSS changes not appearing?
1. Check if Gulp watch is running: `npm run gulp watch`
2. Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)
3. Check browser console for errors (F12)
4. Verify file is in `public/css/` not `public/resources/`

### Containers won't start?
```bash
# Check if ports are in use
sudo lsof -i :80

# View container logs
docker logs ospos_dev
docker logs mysql

# Restart containers
./dev.sh restart
```

### Database connection errors?
```bash
# Wait for MySQL to fully start (takes 5-10 seconds)
docker logs mysql

# Restart containers
./dev.sh restart
```

### Permission errors?
```bash
# Make sure you're using correct user/group IDs
echo "USERID=$(id -u) GROUPID=$(id -g)"

# Containers should run as your user
docker compose -f docker-compose.dev.yml ps
```

## 📝 Development Tips

### Live Editing CSS
1. Open browser DevTools (F12)
2. Split screen: Code editor on one side, browser on the other
3. Edit CSS in your editor
4. Save file (Ctrl+S)
5. Gulp detects change and rebuilds
6. Refresh browser to see changes

### Fast Iteration
- Gulp watch rebuilds only changed files (fast!)
- Debug mode loads individual files (easier to debug)
- Browser cache is minimal in development

### Production Build
When ready to deploy:
```bash
# Stop watch mode (Ctrl+C)
# Build minified production assets
npm run gulp
```

## 🎯 What's Different in Development Mode?

| Feature | Development | Production |
|---------|-------------|------------|
| CSS Files | Individual files loaded | Single minified file |
| JS Files | Individual files loaded | Single minified file |
| Error Display | Shown on screen | Logged only |
| Debug Bar | Enabled | Disabled |
| File Changes | Auto-detected | Requires rebuild |
| Performance | Slower (many files) | Fast (single file) |

## 🌐 Advanced

### Modify Other Assets
- **JavaScript:** Files in `public/js/` - run `npm run gulp debug-js`
- **Images:** Files in `public/images/` - no build needed
- **PHP:** Files in `app/` - changes reflect immediately

### Port Conflicts?
Edit `docker-compose.dev.yml` to change ports:
```yaml
ports:
  - "8080:80"  # Change 8080 to your preferred port
```

### Use Different Database?
Edit `.env` file database settings.

## 📚 Additional Resources

- [INSTALL.md](INSTALL.md) - Full installation guide
- [BUILD.md](BUILD.md) - Build from source guide
- [README.md](README.md) - Project overview
- [Official Wiki](https://github.com/opensourcepos/opensourcepos/wiki)

---

**Happy Coding! 🎉**

For issues, check the [GitHub Issues](https://github.com/opensourcepos/opensourcepos/issues) page.
