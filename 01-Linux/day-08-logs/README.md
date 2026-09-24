# Linux Day 8 - Logs

## Goal

Learn basic Linux log inspection and filtering.

## Commands

```bash
head app.log
tail app.log
head -n 3 app.log
tail -n 3 app.log
grep ERROR app.log
grep -i error app.log
grep -n ERROR app.log
less app.log
tail -f app.log
journalctl -u nginx