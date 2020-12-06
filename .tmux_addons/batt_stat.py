#! /usr/bin/python3
import re

battery_stat = open('/sys/class/power_supply/BAT1/uevent', 'r')

status = battery_stat.read()

#percent = re.search('(?<=POWER_SUPPLY_CHARGE_FULL=)(\d+).*(?<=POWER_SUPPLY_CHARGE_NOW=)(\d+)', status, re.DOTALL)
percent = re.search('POWER_SUPPLY_CAPACITY=(\d+)', status, re.DOTALL)

#print(round(int(percent.group(2)) / int(percent.group(1)) * 100, 2))
print(percent.group(1))

battery_stat.close
