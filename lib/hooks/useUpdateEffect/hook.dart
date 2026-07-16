import 'package:flutter_hooks/flutter_hooks.dart';

void useUpdateEffect(Dispose? Function() effect, [List<Object?>? keys]) {
  final isMounted = useRef(false);
  useEffect(() {
    return () {
      isMounted.value = false;
    };
  }, []);

  useEffect(() {
    if (!isMounted.value) {
      isMounted.value = true;
      return null;
    }

    return effect();
  }, keys);
}
