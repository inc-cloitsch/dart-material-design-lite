/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdlobservable;

class PropertyChangeEvent<T> {
    final T oldValue;
    final T value;

    PropertyChangeEvent(this.value,this.oldValue);
}

@MdlComponentModel
class ObservableProperty<T> {
    final Logger _logger = new Logger('mdlobservable.ObservableProperty');

    T _value;
    Function _observe;
    Duration _interval = new Duration(milliseconds: 100);

    StreamController<PropertyChangeEvent<T>> _onChange;

    ObservableProperty(this._value,{ T observe(), final Duration interval } ) {
        _logger.info("Constructor PROP ${_value}");
        if(interval != null) {
            _interval = interval;
        }
        if(observe != null) {
            observes(observe);
        }
    }

    Stream<PropertyChangeEvent<T>> get onChange {
        if(_onChange == null) {
            _onChange = new StreamController<PropertyChangeEvent<T>>.broadcast();
        }
        return _onChange.stream;
    }

    void set value(final T val) {
        final T old = _value;
        _value = val;

        //_logger.info("Value: $val");
        _fire(new PropertyChangeEvent(val,old));
    }

    T get value => _value;

    void observes( T observe() ) {
        _logger.info("Observes $observe");
        _observe = observe;

        if(_observe != null) {
            // first timer comes after short period - this shows the value
            // for the first time
            new Timer(new Duration(milliseconds: 50),() {
              _setValue();

              // second timer comes after specified time
              new Timer.periodic(_interval,(final Timer timer) {
                  _setValue();
              });

            });
        }
    }

    // - private ----------------------------------------------------------------------------------

    void _setValue() {
        if(_observe != null) {
            final T newValue = _observe();
            if(newValue != _value) {
              value = newValue;
              }
          }
     }

    void _fire(final PropertyChangeEvent<T> event) {
        if(_onChange == null) {
            _onChange = new StreamController<PropertyChangeEvent<T>>.broadcast();
        }
        _onChange.add(event);
    }
}