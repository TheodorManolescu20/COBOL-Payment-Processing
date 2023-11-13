# COBOL-Payment-Processing

This COBOL initiative, denoted as COBIF01, is formulated to handle payment information entered by users. The program systematically extracts payment data for diverse transactions, conducts validation checks on the input, computes the payment amount contingent on card type and country, and classifies transactions into accepted and rejected payments. Subsequently, the processed payment details are presented in a predefined format. Let's delve into the architecture and operational aspects of this COBOL program:
Identification Division:

    Program ID: COBIF01

Environment Division:

    Configuration Section: Configures special names, setting the console as CNSL

Data Division:

    Working-Storage Section:
        - WS-RECORD: Represents an illustrative input record with a fixed length of 23 characters.
        - WS-OUTPUT-FILE: Contains variables designed to store accepted payment data in a predetermined format.
        - WS-REJECT-FILE: Consists of variables designated for storing rejected payment data in a predefined format, inclusive of rejection reasons.
        - WS-INPUT2: Holds variables pertaining to input payment data, encompassing payee name, currency, amount, card type, card number, and country.
        - WS-RATE-EURGBP, WS-RATE-USDGBP, WS-RATE-RONGBP, WS-RATE-BGNGBP: Variables housing currency conversion rates for distinct countries.
        - WS-COUNTER: Serves as a counter variable regulating the number of iterations in the payment processing loop.

Procedure Division:

    Processing Logic:
        - The program initiates a loop, capturing payment details up to 8 times through the PERFORM UNTIL WS-COUNTER = 8 ACCEPT WS-INPUT2 statement.
        - Within each iteration, the program acquires user-input details including the payee name, currency, payment amount, card type, card number, and country.
        - Validation procedures are applied to the card type and country, followed by currency conversion based on the card type and country. Processing fees are deducted, and the transaction is categorized as accepted or rejected.
        - Processed payment details are stored in the WS-OUTPUT-FILE for accepted payments or the WS-REJECT-FILE for rejected payments.

    Output:
        - Accepted payment details (name, converted amount) are presented if the card type is not DIN (Diners Club) using the DISPLAY WS-OUTPUT-FILE UPON CNSL statement.
        - Rejected payment details (card number, amount, country, rejection reason) are displayed for rejected payments using the DISPLAY WS-REJECT-FILE UPON CNSL statement.
        - The program concludes execution after processing the input payments (STOP RUN).

This COBOL program functions as a payment processor, receiving payment details from users, validating the input, executing currency conversion, subtracting processing fees, and classifying payments into either accepted or rejected transactions. It adeptly manages diverse card types, countries, and rejection scenarios, guaranteeing precise processing and transparent reporting of both accepted and rejected payments. The methodical design facilitates straightforward modifications and expansions to incorporate additional payment processing logic or seamless integration into broader financial systems.        
