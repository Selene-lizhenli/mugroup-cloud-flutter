import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

BehaviorSubject<T> useBehaviorSubject<T>([T? value]) {
  final ref = useRef(
      value != null ? BehaviorSubject<T>.seeded(value) : BehaviorSubject<T>());

  useEffect(() {
    return () {
      ref.value.close();
    };
  }, []);

  return ref.value;
}
