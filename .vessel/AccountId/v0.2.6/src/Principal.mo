import Array "mo:base-0.7.3/Array";
import Base32 "mo:encoding/Base32";
import Blob "mo:base-0.7.3/Blob";
import Char "mo:base-0.7.3/Char";
import CRC32 "mo:hash/CRC32";
import Nat8 "mo:base-0.7.3/Nat8";
import Nat32 "mo:base-0.7.3/Nat32";
import Prim "mo:⛔"; // Char.toLower();
import Principal "mo:base-0.7.3/Principal";

module {
    public let fromText : (t : Text) -> Principal = Principal.fromText;

    public let toText : (p : Principal) -> Text = Principal.toText;

    public func fromBlob(b : Blob) : Principal {
        let bs  = Blob.toArray(b);
        let cs = nat32ToNat8Array(CRC32.checksum(bs));
        let b32 = Base32.encode(Array.tabulate<Nat8>(
            4 + bs.size(),
            func (i : Nat) : Nat8 {
                if (i < 4) return cs[i];
                return bs[i - 4];
            }
        ));
        Principal.fromText(format(b32));
    };

    public let toBlob : (p : Principal) -> Blob = Principal.toBlob;

    public func format(bs : [Nat8]) : Text {
        var id = "";
        for (i in bs.keys()) {
            let c = Prim.charToLower(Char.fromNat32(nat8ToNat32(bs[i])));
            id #= Char.toText(c);
            if ((i + 1) % 5 == 0 and i + 1 != bs.size()) {
                id #= "-"
            };
        };
        id;
    };

    private func nat8ToNat32(n : Nat8) : Nat32 {
        Nat32.fromNat(Nat8.toNat(n));
    };

    private func nat32ToNat8(n : Nat32) : Nat8 {
        Nat8.fromNat(Nat32.toNat(n) % 256);
    };

    private func nat32ToNat8Array(n : Nat32) : [Nat8] {
        [
            nat32ToNat8(n >> 24),
            nat32ToNat8(n >> 16),
            nat32ToNat8(n >> 8),
            nat32ToNat8(n),
        ];
    };
}
