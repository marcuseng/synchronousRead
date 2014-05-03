#### See [LICENSE](LICENSE.txt)

##EE201 Final Project | Spring 2014

This project demonstrates the interaction of the FPGA with the external Cellular RAM using the parallel interface. We synchronously read the external memory at 50 MHz and attempt to display the contents to a VGA monitor. We did not get as far as we hoped but extending the project can be easily done in order to get it to work properly.

The FPGA is configured to read 128 words (16 bits = 1 word) per burst signal, storing the data retrieved to a simple 2D register. The VGA controller is then able to read off of the data from the temporary register and display it to the monitor.

Data is read starting from the 0th address on the RAM. Toggling the up and down buttons on the board triggers a read from the next or previous hardcoded address (such as the next or previous image location). Toggling the left/right buttons shows the current two bytes to the SSDs and allows you to see the next or previous.

There is one bug, requiring the user to reset continulously until the read properly initiates. We believe this bug is caused by the memory and FPGA needing time to properly configure.

It took my lab partner and I approximately 80 hours to get to what we have here, starting from scratch. We hope that this can provide a starting point for anyone who wishes to work with interfacing with external memory.