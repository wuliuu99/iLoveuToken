module iloveu::loveu {
    use std::option;
    use std::ascii;
    use std::vector;
    use std::string::{Self, utf8};
    use sui::url;
    use sui::coin;
    use sui::transfer::{public_transfer, public_share_object};
    use sui::tx_context::{TxContext, sender};

    struct LOVEU has drop {}

    fun init(w: LOVEU, ctx: &mut TxContext) {
        // 12 decimals max
        // each char is one decimal place
        let decimals_buffer = b"111111      ";
        let decimals = vector::length(&trim_right(decimals_buffer));

        // 8 chars max
        let symbol_buffer = b"LOVEU   ";
        let symbol = ascii::into_bytes(string::to_ascii(utf8(trim_right(symbol_buffer))));

        // 32 chars max
        let name_buffer = b"iloveu token                    ";
        let name = trim_right(name_buffer);

        // 320 chars max
        //let description_buffer = x"54686520776f726c642773206669727374207375737461696e61626c65204d6172696e65204171756163756c7475726520546f6b656e2028546f6b656e290a546f2070726f6d6f7465207375737461696e61626c6520626c756520666f6f6420646576656c6f706d656e7420616e64206d61696e7461696e206d6172696e65204171756163756c74757265207265736f75726365732e2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020";
        let description_buffer = b"Send this token to the opposite sex to express your love";
        let description = trim_right(description_buffer);

        // 320 chars max
        let icon_url_buffer = b"https://raw.githubusercontent.com/wuliuu99/iLoveuToken/refs/heads/main/love%20u%20200.png                                                                                                                                                                                                                                       "; 
        let icon_url = trim_right(icon_url_buffer);
        let icon_url = if (vector::length(&icon_url) == 0) {
            option::none()
        } else {
            option::some(url::new_unsafe_from_bytes(icon_url))
        };

        let (mint_cap, meta) = coin::create_currency(
            w,
            (decimals as u8),
            symbol,
            name,
            description,
            icon_url,
            ctx,
        );

        // the sender can mint, burn and update meta
        public_transfer(mint_cap, sender(ctx));
        // public to allow edits
        public_share_object(meta);
    }
    
    fun trim_right(buf: vector<u8>): vector<u8> {
        let space_byte_code: &u8 = &32;
        while (vector::length(&buf) > 0) {
            if (vector::borrow(&buf, vector::length(&buf) - 1) != space_byte_code) {
                // stop at first non-space char from right
                break
            };

            vector::pop_back(&mut buf);
        };

        buf
    }
}

