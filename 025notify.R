# Send notifications if there are errors/mismatches between EMu & Filer logs

# or help installing mailR & java on ubuntu, try:
# https://github.com/hannarud/r-best-practices/wiki/Installing-RJava-(Ubuntu)

# if (file.exists(paste0("auditErrorlog_", filerDate, ".txt"))) {

sender <- Sys.getenv("SENDER")
recipients <- c(Sys.getenv("RECIP1"), Sys.getenv("RECIP2")) # Sys.getenv("RECIPTEST")
  
send.mail(from = sender,
          to = recipients,
          subject = paste("EMu/Filer Validation results for", filerDate),
          body = " Filer Recap \n If any errors, a 2nd 'checkMissing' log will be attached. \n If any MD5 mismatches, an 'md5nomatch' csv will also be attached.",
          encoding = "utf-8",
          smtp = list(host.name = "aspmx.l.google.com", port = 25), 
                      # user.name = Sys.getenv("SENDER"),            
                      # passwd = Sys.getenv("SENDPW"), ssl = TRUE),
          authenticate = FALSE,
          send = TRUE,
          attach.files = c("./output/FilerRecap.csv", 
                           
                           if (file.exists(paste0(Sys.getenv("OUT_DIR"), "checkMissingFiles_",
                                                  format(max(timeEMu$ctime), "%Y%m%d_%a"),
                                                  ".csv"))) {
                             paste0(Sys.getenv("OUT_DIR"), "checkMissingFiles_",
                                    format(max(timeEMu$ctime), "%Y%m%d_%a"),
                                    ".csv")
                           },
                           
                           if (file.exists(paste0(Sys.getenv("OUT_DIR"), "md5nomatch.csv"))) {
                             paste0(Sys.getenv("OUT_DIR"), "md5nomatch.csv")
                           }),
          
          file.descriptions = c("Description for filer recap", 
                                if (file.exists(paste0(Sys.getenv("OUT_DIR"),"checkMissingFiles_",
                                                        format(max(timeEMu$ctime), "%Y%m%d_%a"),
                                                        ".csv"))) {
                                  "Description for error log"
                                  
                                  },
                                
                                if (file.exists(paste0(Sys.getenv("OUT_DIR"), "md5nomatch.csv"))) {
                                  "Description for non-matching EMu MD5sums"
                                }), # optional parameter
          debug = TRUE)
