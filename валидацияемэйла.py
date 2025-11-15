{
  "nbformat": 4,
  "nbformat_minor": 0,
  "metadata": {
    "colab": {
      "provenance": [],
      "authorship_tag": "ABX9TyMqovqrYEq0HQrnHsZMkUai"
    },
    "kernelspec": {
      "name": "python3",
      "display_name": "Python 3"
    },
    "language_info": {
      "name": "python"
    }
  },
  "cells": [
    {
      "cell_type": "markdown",
      "source": [
        "# New Section"
      ],
      "metadata": {
        "id": "HhB4GSdQFogj"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "class correct_email:\n",
        "    def __init__(self, input_email):\n",
        "        self.input_email = input_email\n",
        "        self.com = '.com'\n",
        "        self.ru = '.ru'\n",
        "    def onle_com_or_ru(self):\n",
        "      if (self.input_email.endswith('.com') or\n",
        "         self.input_email.endswith('.ru')):\n",
        "         return 'YES'\n",
        "      else:\n",
        "        return 'NO'\n",
        "\n",
        "\n",
        "input_email = input()\n",
        "answer = correct_email(input_email)  # Создаем объект\n",
        "result = answer.onle_com_or_ru()      # Вызываем метод объекта\n",
        "print(result)\n"
      ],
      "metadata": {
        "id": "q8MduNh2racL",
        "colab": {
          "base_uri": "https://localhost:8080/"
        },
        "outputId": "b6116c3c-0bdc-4430-fe81-e9da1f8a8d70"
      },
      "execution_count": 7,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "seflsnlv@skjdbcbk.com\n",
            "YES\n"
          ]
        }
      ]
    },
    {
      "cell_type": "markdown",
      "source": [
        "Метод startswith()\n",
        "Метод startswith(<prefix>, <start>, <end>) определяет, начинается ли исходная строка s подстрокой <prefix>. Метод возвращает значение True, если исходная строка начинается с подстроки <prefix>, или False в противном случае.\n",
        "\n",
        "Приведённый ниже код:\n",
        "\n",
        "s = 'foobar'\n",
        "print(s.startswith('foo'))\n",
        "print(s.startswith('baz'))"
      ],
      "metadata": {
        "id": "rfRL9lyw401v"
      }
    }
  ]
}