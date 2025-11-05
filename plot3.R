# plot3.R
# Recreate Plot 3: Energy sub metering (1/2/3) over time for 2007-02-01 and 2007-02-02
# Output: plot3.png (480x480), base graphics only

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

# ---------- Read full file then subset (portable) ----------
dat <- read.table(
  txt_file,
  header = TRUE,
  sep = ";",
  na.strings = "?",
  colClasses = c("character","character",rep("numeric",7))  # keep Date/Time as char
)

dat <- subset(dat, Date %in% c("1/2/2007","2/2/2007"))

# Ensure English weekday labels (Thu/Fri/Sat)
old_locale <- Sys.getlocale("LC_TIME")
on.exit(try(Sys.setlocale("LC_TIME", old_locale), silent = TRUE))
try(Sys.setlocale("LC_TIME", "C"), silent = TRUE)

# Combine Date + Time into POSIXct
dat$Datetime <- as.POSIXct(strptime(paste(dat$Date, dat$Time), "%d/%m/%Y %H:%M:%S"))

# ---------- Plot to PNG ----------
png("plot3.png", width = 480, height = 480)

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

dev.off()
