
# JSON parser/serializer

The source for the reuse-lang implementation:
```clojure
(alias (object) (dictionary string record))
(sum (record) (Object object)
              (String string))

(function parse (input) ...)

(function get_string_from_object (object key)
    (dictionary_get_string object key))

(export_function parse json_parse object (string))
(export_function get_string_from_object json_object_get_string (result string) (object string))
```

`(result string)` is defined as:

```clojure
(sum (result T) (Some T)
                (None))
```

Using the generated C library:
```c
#include <json.h>
#include <stdio.h>

int main(int argc, char** argv) {
    REUSE_STRING key, value, input;
    JSON_OBJECT json_object;
    RESULT_STRING result;

    input = REUSE_MALLOC_STRING("{\"key\": \"value\"}");
    key = REUSE_MALLOC_STRING("key");

    json_object = json_parse(input);

    // User defined getter/setter interface for JsonObject ADT
    result = json_object_get_string(json_object, key);
    if (result_string_is_none(result) == 0) {
        printf("Could not index JSON object, key '%s' not found.", REUSE_CSTR(key));
        REUSE_FREE(input);
        REUSE_FREE(key);
        return 1;
    }

    value = result_string_get_some(result);
    printf("Value: %s", REUSE_CSTR(value));

    REUSE_FREE(input);
    REUSE_FREE(key);
    REUSE_FREE(value);

    return 0;
}
```

## Design problems
- How do we name ADT accessors? `result_string_is_none` is a trivial example, how do we do this for

```clojure
(sum (tuple (list A) B) (First (list A))
                        (Second B))
```
`tuple_list_string_integer_is_first`? Is this disambiguous?


# TODO app
```java

import com.reuse_lang.json;

class Application {
    public static void main() {
        TodoList todo = new TodoList();


    }
}

```
