# 🚀 OSPOS Development - Quick Start

## Start Everything (One Command)
```bash
./dev.sh start
```

Then in a **separate terminal**:
```bash
npm run gulp watch
```

## Access the App
- **URL:** http://localhost
- **Login:** admin / pointofsale

## Edit CSS and See Changes Instantly
1. Open `public/css/ospos.css` (or any CSS file in `public/css/`)
2. Make your changes
3. Save the file (Ctrl+S)
4. Refresh browser (F5 or Ctrl+R)
5. See your changes! 🎉

## Common Commands
```bash
./dev.sh status     # Check if containers are running
./dev.sh logs       # View application logs
./dev.sh stop       # Stop everything
./dev.sh restart    # Restart everything
```

## Troubleshooting
- **Changes not showing?** Hard refresh browser: Ctrl+Shift+R
- **Gulp not watching?** Run: `npm run gulp watch`
- **Containers stopped?** Run: `./dev.sh start`

## Full Documentation
See [DEVELOPMENT.md](DEVELOPMENT.md) for complete guide.

---
**That's it! Start coding! 🎨**
