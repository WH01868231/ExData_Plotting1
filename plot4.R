# plot4.R
# Recreate Plot 4: Four-panel visualization for Feb 1–2, 2007
# Output: plot4.png (480x480)

# ---------- Download + prepare data (idempotent) ----------
zip_url  <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_file <- "household_power_consumption.zip"
txt_file <- "household_power_consumption.txt"

if (!file.exists(txt_file)) {
  if (!file.exists(zip_file)) {
    download.file(zip_url, destfile = zip_file, mode = "wb")
  }
  unzip(zip_file)
}

# ---------- Read and subset ----------
dat <- read.table(
  txt_file,
  header = TRUE,
  sep = ";",
  na.strings = "?",
  colClasses = c("character","character",rep("numeric",7))
)
dat <- subset(dat, Date %in% c("1/2/2007","2/2/2007"))

# Ensure English weekday labels (Thu/Fri/Sat)
old_locale <- Sys.getlocale("LC_TIME")
on.exit(try(Sys.setlocale("LC_TIME", old_locale), silent = TRUE))
try(Sys.setlocale("LC_TIME", "C"), silent = TRUE)

# Combine Date + Time
dat$Datetime <- as.POSIXct(strptime(paste(dat$Date, dat$Time), "%d/%m/%Y %H:%M:%S"))

# ---------- Plot to PNG ----------
png("plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2))  # 2x2 grid layout

# (1,1) Global Active Power
plot(dat$Datetime, dat$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power")

# (1,2) Voltage
plot(dat$Datetime, dat$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage")

# (2,1) Energy Sub Metering
plot(dat$Datetime, dat$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering")
lines(dat$Datetime, dat$Sub_metering_2, col = "red")
lines(dat$Datetime, dat$Sub_metering_3, col = "blue")
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1,
       bty = "n")

# (2,2) Global Reactive Power
plot(dat$Datetime, dat$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")

dev.off()
