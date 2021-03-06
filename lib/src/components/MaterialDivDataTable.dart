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
part of mdlcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialDivDataTableCssClasses {

    final String DATA_TABLE =   'mdl-data-tableex';
    final String SELECTABLE =   'mdl-data-tableex--selectable';
    final String SELECT =       'mdl-data-table__select';

    final String IS_SELECTED =  'is-selected';
    final String IS_UPGRADED =  'is-upgraded';

    final String HEAD = "mdl-div-data-tableex__head";
    final String ROW =  "mdl-div-data-tableex__row";

    final String CELL_CHECKBOX = "mdl-data-tableex__cell--checkbox";

    final String CHECKBOX = "mdl-checkbox";
    final String CHECKBOX_INPUT = "mdl-checkbox__input";

    final String JS_CHECKBOX = "mdl-js-checkbox";
    final String JS_RIPPLE_EFFECT = "mdl-js-ripple-effect";

    const _MaterialDivDataTableCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialDivDataTableConstant {

    static const String WIDGET_SELECTOR = "mdl-data-tableex";

    final String SELECTABLE_NAME =  "mdl-data-tableex-selectable-name";
    final String SELECTABLE_VALUE = "mdl-data-tableex-selectable-value";

    const _MaterialDivDataTableConstant();
}

class MaterialDivDataTable extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialDivDataTable');

    static const _MaterialDivDataTableConstant _constant = const _MaterialDivDataTableConstant();
    static const _MaterialDivDataTableCssClasses _cssClasses = const _MaterialDivDataTableCssClasses();

    MaterialDivDataTable.fromElement(final dom.HtmlElement element, final di.Injector injector)
        : super(element, injector) {

        _init();
    }

    static MaterialDivDataTable widget(final dom.HtmlElement element) => mdlComponent(element,MaterialDivDataTable) as MaterialDivDataTable;

    // Central Element - by default this is where mdl-data-table can be found (element)
    // html.Element get hub => inputElement;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialDivDataTable - init");

        final dom.HtmlElement firstHeader = element.querySelector(".${_cssClasses.HEAD}");

        final List<dom.HtmlElement> rows = new List.from(element.querySelectorAll(".${_cssClasses.ROW}") as List<dom.HtmlElement>);
        rows.removeWhere((final dom.HtmlElement element) => element.classes.contains(_cssClasses.HEAD));

        if (element.classes.contains(_cssClasses.SELECTABLE)) {

            final dom.HtmlElement th = new dom.DivElement();
            th.classes.add(_cssClasses.CELL_CHECKBOX);

            final dom.LabelElement headerCheckbox = _createCheckbox(null, rows);
            th.append(headerCheckbox);
            firstHeader.insertAdjacentElement("afterBegin", th);

            rows.forEach((final dom.HtmlElement row) {

                final dom.HtmlElement firstCell = row.querySelector(':first-child');
                if (firstCell != null) {

                    final dom.HtmlElement td = new dom.DivElement();
                    td.classes.add(_cssClasses.CELL_CHECKBOX);

                    final dom.LabelElement rowCheckbox = _createCheckbox(row,null);
                    td.append(rowCheckbox);

                    row.insertBefore(td, firstCell);
                }
            });
        }

        componentHandler().upgradeElement(element);
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// Creates a checkbox for a single or or multiple rows and hooks up the
    /// event handling.
    dom.LabelElement _createCheckbox(final dom.TableRowElement row, final List<dom.HtmlElement> optRows) {

        final dom.LabelElement label = new dom.LabelElement();

        label.classes.add(_cssClasses.CHECKBOX);
        label.classes.add(_cssClasses.JS_CHECKBOX);
        label.classes.add(_cssClasses.JS_RIPPLE_EFFECT);
        label.classes.add(_cssClasses.SELECT);

        final dom.CheckboxInputElement checkbox = new dom.CheckboxInputElement();
        checkbox.classes.add(_cssClasses.CHECKBOX_INPUT);

        if (row != null) {
            checkbox.checked = row.classes.contains(_cssClasses.IS_SELECTED);

            // .addEventListener('change', -- .onChange.listen(<Event>);
            checkbox.onChange.listen( _selectRow(checkbox, row, null));

            if (row.dataset.containsKey(_constant.SELECTABLE_NAME)) {
                checkbox.name = row.dataset[_constant.SELECTABLE_NAME];
            }
            if (row.dataset.containsKey(_constant.SELECTABLE_VALUE)) {
                checkbox.value = row.dataset[_constant.SELECTABLE_VALUE];
            }

        } else if (optRows != null && optRows.isNotEmpty) {

            // .addEventListener('change', -- .onChange.listen(<Event>);
            checkbox.onChange.listen( _selectRow(checkbox, null, optRows));
        }

        label.append(checkbox);
        return label;
    }

    /// Generates and returns a function that toggles the selection state of a
    /// single row (or multiple rows).
    ///
    /// [checkbox] Checkbox that toggles the selection state.
    /// [row] to toggle when checkbox changes.
    /// [rows] to toggle when checkbox changes.
    Function _selectRow(final dom.CheckboxInputElement checkbox, final dom.TableRowElement row, final List<dom.HtmlElement> optRows) {

        if (row != null) {

            return (final dom.Event event) {
                if (checkbox.checked) {
                    row.classes.add(_cssClasses.IS_SELECTED);

                } else {
                    row.classes.remove(_cssClasses.IS_SELECTED);
                }
            };
        }

        if (optRows != null && optRows.isNotEmpty) {

            return (final dom.Event event) {

                dom.HtmlElement el;
                if (checkbox.checked) {
                    for (int i = 0; i < optRows.length; i++) {
                        el = optRows[i].querySelector(".${_cssClasses.CHECKBOX_INPUT}");
                        MaterialCheckbox.widget(el).check();
                        optRows[i].classes.add(_cssClasses.IS_SELECTED);
                    }

                } else {
                    for (int i = 0; i < optRows.length; i++) {
                        el = optRows[i].querySelector(".${_cssClasses.CHECKBOX_INPUT}");
                        MaterialCheckbox.widget(el).uncheck();
                        optRows[i].classes.remove(_cssClasses.IS_SELECTED);
                    }
                }
            };
        }
        return null;
    }
}

/// registration-Helper
void registerMaterialDivDataTable() {
    final MdlConfig config = new MdlWidgetConfig<MaterialDivDataTable>(
        _MaterialDivDataTableConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element, final di.Injector injector) => new MaterialDivDataTable.fromElement(element, injector)
    );
    componentHandler().register(config);
}

