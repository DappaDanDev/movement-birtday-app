module onchain_birthday::onchain_birthday {
    use std::error;
    use std::signer;
    use std::string;
    use aptos_framework::event;

  struct Birthday has key, store, drop {
      name: string::String,
      birthday: string::String,
      account: address
  }
  
  public entry fun register(account: &signer, name: string::String, birthday: string::String) acquires Birthday {
      let addr = signer::address_of(account);
      
      // Check if a Birthday already exists for the account
      if (exists<Birthday>(addr)) {
          // Remove the existing Birthday
          let _old_Birthday = move_from<Birthday>(addr);
      };
      
      // Create the new Birthday
      let new_birthday = Birthday {
          name,
          birthday,
          account: addr
      };
      
      // Store the new Birthday under the account
      move_to(account, new_birthday);
  }

  #[view]
  public fun get_birthday(addr: address): (bool, string::String, string::String) acquires Birthday {
      if (exists<Birthday>(addr)) {
          let birthday = borrow_global<Birthday>(addr);
          (true, birthday.name, birthday.birthday)
      } else {
          (false, string::utf8(b""), string::utf8(b""))
      }
  }
}
